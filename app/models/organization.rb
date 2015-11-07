class Organization < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :employees, through: :employees_organizations
  has_many :repos, dependent: :destroy

  def previous
    self.class.where(["id < ?", id]).last
  end

  def next
    self.class.where(["id > ?", id]).first
  end

  def sync!(year)
    OrganizationSyncer.perform_async(id, year)
  end

  def fetch_repos!
    repos.create(name: 'test')
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
