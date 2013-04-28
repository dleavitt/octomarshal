require "rubygems"
require "securerandom"
require "logger"
require "bundler"
Bundler.require :default, ENV['RACK_ENV'] || :development
require "sinatra/reloader"

root = File.dirname(__FILE__)

# require everything in lib folder
Dir[File.join(root, "lib" "**", "*.rb")].each(&method(:require))

# set env variables from env.yml
envfile = File.join(root, "config", "env.yml")
YAML.load_file(envfile).each { |k,v| ENV[k] = v } if File.exist?(envfile)

$redis = Redis::Namespace.new(:octomarshal, :redis => Redis.new(
  :url      => ENV['REDIS_URL'] || ENV['REDISTOGO_URL'],
  :logger   => Logger.new(STDOUT)
))

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

      def github_client(params = {})
        params[:user] ||= session[:user]
        params[:oauth_token] ||= session[:token]

        Github.new({
          :client_id      => ENV['GITHUB_CLIENT_ID'],
          :client_secret  => ENV['GITHUB_CLIENT_SECRET'],
        }.merge(params))
      end

      def authorized?
        session[:user] && session[:token]
      end
    end

    get "/" do
      erb  authorized? ? :app : login
    end

    get "/login" do
      redirect github_client.authorize_url(scope: 'repo')
    end

    get "/auth/callback" do
      # TODO: handle failure
      token = github_client.get_token(params[:code]).token
      github = github_client(oauth_token: token)
      user = github.users.get

      session[:user] = user.login
      session[:token] = github.oauth_token

      redirect "/"
    end

    post "/logout" do
      session[:user] = session[:token] = nil
      redirect "/"
    end

    namespace "/api" do
      before do
        halt 403, "Not authorized" unless authorized?
      end

      get "/" do
        json({a: 1})
      end
    end
  end
end