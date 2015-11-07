class Organization < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :employees, through: :employees_organizations
  has_many :repos, dependent: :destroy

  def sync!(year)
    OrganizationSyncer.perform_async(id, year)
  end

  def fetch_repos!
    repos.create
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
