class ChangeBookConsignorToUser < ActiveRecord::Migration
  def change
    rename_column :books, :consignor_id, :user_id
  end
end
