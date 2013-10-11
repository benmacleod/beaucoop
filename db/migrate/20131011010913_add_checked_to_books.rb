class AddCheckedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :checked, :boolean
  end
end
