class AddConsigneeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :consignee, :text
  end
end
