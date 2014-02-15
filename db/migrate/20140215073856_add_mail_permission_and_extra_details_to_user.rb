class AddMailPermissionAndExtraDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :direct_email, :boolean
    add_column :users, :contact_details, :text
  end
end
