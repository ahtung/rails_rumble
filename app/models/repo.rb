class Repo < ActiveRecord::Base
  # Relations
  belongs_to :organization
  has_many :employees_repos, dependent: :destroy
  has_many :contributors, source: :employee, through: :employees_repos
end
