class Employee < ActiveRecord::Base
  # Relations
  has_many :employees_organizations, dependent: :destroy
  has_many :organizations, through: :employees_organizations
end
