class CreateEmployeesRepos < ActiveRecord::Migration
  def change
    create_table :employees_repos, id: false do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :repo, index: true
    end
  end
end
