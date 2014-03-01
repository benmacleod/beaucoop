class AddWarnedAtToBook < ActiveRecord::Migration
  def change
    add_column :books, :warned_at, :date
  end
end
