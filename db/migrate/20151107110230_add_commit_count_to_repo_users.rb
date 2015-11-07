class AddCommitCountToRepoUsers < ActiveRecord::Migration
  def change
    add_column :organizations, :commits, :text
  end
end
