class AddIndexesToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, :user_id
    add_index :memberships, :organization_id
  end
end
