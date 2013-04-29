require "rubygems"
require "securerandom"
require "logger"
require "bundler"
Bundler.require :default, ENV['RACK_ENV'] || :development
require "sinatra/reloader"

root = File.dirname(__FILE__)

# require everything in lib folder
Dir[File.join(root, "lib", "**", "*.rb")].each(&method(:require))

# set env variables from env.yml
envfile = File.join(root, "config", "env.yml")
YAML.load_file(envfile).each { |k,v| ENV[k] = v } if File.exist?(envfile)

$redis = Redis::Namespace.new(:octomarshal, :redis => Redis.new(
  :url      => ENV['REDIS_URL'] || ENV['REDISTOGO_URL'],
  :logger   => Logger.new(STDOUT)
))

$memcached = Dalli::Client.new('localhost:11211')

HandlebarsAssets::Config.template_namespace = 'HBS' if defined? HandlebarsAssets

module Octomarshal
  class App < Sinatra::Base

    # middlewares
    use Rack::PostBodyContentTypeParser
    use Rack::Session::Redis,
      :redis_server => "#{$redis.client.id}/octomarshal:session"
    use Rack::Csrf, :raise => true

    # sinatra extensions
    register Sinatra::Contrib
    register Sinatra::Reloader if development?
    also_reload File.join(root, "lib", "**.rb")

    # config
    enable :method_override

    helpers do
      include Sprockets::Helpers

      # github client
      def gh(params = {})
        params[:user] ||= session[:user]
        params[:oauth_token] ||= session[:token]

        GithubAPI.new({
          client_id:       ENV['GITHUB_CLIENT_ID'],
          client_secret:   ENV['GITHUB_CLIENT_SECRET'],
        }.merge(params))
      end

      def authorized?
        session[:user] && session[:token]
      end
    end

    get "/" do
      erb  authorized? ? :app : :login
    end

    get "/login" do
      redirect gh.client.authorize_url(scope: 'repo')
    end

    get "/auth/callback" do
      # TODO: handle failure

      token = gh.client.get_token(params[:code]).token
      github = gh(oauth_token: token).client
      user = github.users.get

      session[:user] = user.login
      session[:token] = token

      # $redis.set "users:#{user.login}", token

      redirect "/"
    end

    post "/logout" do
      session[:user] = session[:token] = nil

      if request.xhr?
        json status: true, location: "/"
      else
        redirect "/"
      end
    end

    namespace "/api" do
      helpers do
        def cache_key
          session[:user] + "-" + params.values.join("-") + request.path
        end

        def cache
          $memcached.fetch(cache_key, 300) { yield }
        end
      end

      before do
        halt 403, "Not authorized" unless authorized?
      end

      # get user's organizations
      get "/orgs" do
        # TODO: filter by whether user is an owner
        # TODO: return only required attributes
        cache { json gh.orgs }

      end

      get "/orgs/:org/repos" do
        cache { json gh.repos(params[:org]) }
      end

      get "/orgs/:org/users" do

        # TODO: allow for manual input of user info, mash this up with that
        cache { json gh.org_users(params[:org]) }
      end

      get "/orgs/:org/teams" do
        json gh.org_teams(params[:org])
      end

      # create a repo team
      post "/orgs/:org/teams" do
        json gh.create_repo_team(params[:org], params[:slug])
      end
    end
  end
end