class CreateEmployeesOrganizations < ActiveRecord::Migration
  def change
    create_table :employees_organizations, id: false do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :organization, index: true
    end
  end
end
