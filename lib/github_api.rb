class GithubAPI
  attr_accessor :client

  def initialize(options = {})
    defaults = {
      auto_pagination: true,
      per_page: 100,
    }
    @client = Github.new(defaults.merge(options))
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

  def org_users(org)
    client.orgs.members.list(org).map do |member|
      member.slice(:login, :id, :html_url, :avatar_url, :gravatar_id)
    end
  end

  def org_teams(org)
    client.orgs.teams.all(org).map do |team|
      team.slice(:id, :name, :slug, :permission)
    end
  end
end