class AddExpiryDateToBook < ActiveRecord::Migration
  def change
    add_column :books, :expiry_date, :date
  end
end
