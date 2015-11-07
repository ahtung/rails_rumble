class EmployeesRepo < ActiveRecord::Base
  belongs_to :employee
  belongs_to :repo
end
