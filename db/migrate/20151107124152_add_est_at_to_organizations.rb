class AddEstAtToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :est_at, :datetime
  end
end
