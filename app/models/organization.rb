class Organization < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :employees, through: :employees_organizations

  def sync!
    OrganizationSyncer.perform_async(id)
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
