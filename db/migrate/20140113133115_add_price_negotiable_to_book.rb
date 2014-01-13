class AddPriceNegotiableToBook < ActiveRecord::Migration
  def change
    add_column :books, :price_negotiable, :boolean
  end
end
