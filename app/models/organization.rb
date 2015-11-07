class Organization < ActiveRecord::Base
  # Relations
  has_many :repos, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  serialize :commits, Hash

  def previous
    self.class.where(["id < ?", id]).last
  end

  def next
    self.class.where(["id > ?", id]).first
  end

  def sync!(year, user)
    OrganizationSyncer.perform_async(id, year, user.id)
  end

  def fetch_repos_as_user!(user)
    client = user.client
    return if client.nil?
    reps = client.repos(name, per_page: 100)
    while client.last_response.rels[:next]
      reps.concat client.last_response.rels[:next].get.data
    end
    reps.each do |repo|
      repos.where(name: repo.name).first_or_create
    end
  end

  def fetch_members_for!(org, client)
    members = org.rels[:members].get.data
    while client.last_response.rels[:next]
      members.concat client.last_response.rels[:next].get.data
    end
    members.each do |member|
      users.where(login: member.login).first_or_create
    end
  end

  def employees_of_the_year(year)
    return [] if commits.blank?
    commits[year].map do |month, monthly_scores|
      best = monthly_scores.reject{|k, v| v == 0 }.max_by{|k,v| v}
      best.nil? ? '' : best.first
    end
  end
end
