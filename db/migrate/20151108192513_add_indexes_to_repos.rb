class AddIndexesToRepos < ActiveRecord::Migration
  def change
    add_index :repos, :organization_id
  end
end
