class AddMissingRelations < ActiveRecord::Migration
  def change
    create_table :repos_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :repo, index: true
    end
  end
end
