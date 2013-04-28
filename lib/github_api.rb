class GithubAPI
  attr_accessor :client

  def initialize(options = {})
    @client = Github.new(options)
  end

  def orgs
    client.orgs.list.map { |o| o.slice(:login, :id, :avatar_url) }
  end

  def repos(org)
    client.repos.list(org: org).map do |repo|
      repo.slice(:name, :id, :private, :html_url, :description, :created_at,
                 :updated_at, :language)
    end
  end
end