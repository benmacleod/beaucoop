class RenameBookConsignedDateToConsignmentDate < ActiveRecord::Migration
  def change
    rename_column :books, :consigned_date, :consignment_date
  end
end
