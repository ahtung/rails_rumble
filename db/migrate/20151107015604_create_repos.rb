class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :organization_id

      t.timestamps null: false
    end
  end
end
