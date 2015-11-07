class DropEmployees < ActiveRecord::Migration
  def change
    drop_table :employees
    drop_table :employees_organizations
    drop_table :employees_repos
  end
end
