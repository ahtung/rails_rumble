class Employee < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :organizations, through: :employees_organizations
  has_many :employees_repos, dependent: :destroy
  has_many :repos, through: :employees_repos
end
