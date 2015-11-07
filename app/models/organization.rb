class Organization < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :employees, through: :employees_organizations
  has_many :repos, dependent: :destroy
  has_many :memberships
  has_many :users, through: :memberships

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
    reps = client.repos(name)
    while client.last_response.rels[:next]
      reps.concat client.last_response.rels[:next].get.data
    end
    reps.each do |repo|
      puts repo.name
      repos.where(name: repo.name).first_or_create
    end
  end

  def employees_of_the_year(year)
    [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
    ]
  end
end
