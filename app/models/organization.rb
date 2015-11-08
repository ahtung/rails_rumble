class Organization < ActiveRecord::Base
  # Relations
  has_many :repos, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  serialize :commits, Hash

  before_create :set_state
  after_commit :set_commits, on: :update, if: :est_at?

  def previous(user)
    memberships = user.memberships.where("organization_id < ?", id)
    previous = memberships.order(organization_id: :asc).last.organization_id if memberships.present?
    self.class.find(previous) if previous.present?
  end

  def next(user)
    memberships = user.memberships.where("organization_id > ?", id)
    next_organization = memberships.order(organization_id: :asc).first.organization_id if memberships.present?
    self.class.find(next_organization) if next_organization.present?
  end

  def sync!(year, user)
    OrganizationSyncer.perform_async(id, year, user.id)
  end

  def fetch_repos_as_user!(user)
    client = user.client
    return if client.nil?
    reps = client.repos(name)
    reps.concat(client.last_response.rels[:next].get.data) while client.last_response.rels[:next]
    if ENV['REPO_LIMIT'] == 'false'
      reps.each { |repo| repos.where(name: repo.name).first_or_create }
    else
      limit = ENV['REPO_LIMIT'].to_i
      reps.first(limit).each { |repo| repos.where(name: repo.name).first_or_create }
    end
  end

  def fetch_members_for!(org, client)
    members = org.rels[:members].get.data
    members.concat(client.last_response.rels[:next].get.data) while client.last_response.rels[:next]
    members.each do |member|
      new_user = users.where(login: member.login).first_or_create
      new_user.update(avatar_url: member.avatar_url)
    end
  end

  def employees_of_the_year(year)
    return Array.new(12) if commits.blank?
    return Array.new(12) if commits[year].nil?
    commits[year].map do |month, monthly_scores|
      best = monthly_scores.max_by { |k,v| v }
      if best.nil?
        nil
      else
        best_index = users.map(&:login).index(best.first)
        (best.last == 0) ? [best, -1] : [best, best_index]
      end
    end
  end

  def set_commits
    return unless commits.blank?
    yearly = {}
    year_first = est_at.strftime("%Y").to_i
    year_now = Time.now.strftime("%Y").to_i
    [*year_first..year_now].each do |year|
      yearly.merge!(year => {})
      [*1..12].each do |month|
        yearly[year].merge!(month => {})
      end
    end
    update_attribute(:commits, yearly)
  end

  private

  def set_state
    state = 'waiting'
  end
end
