class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text      :title
      t.text      :author
      t.text      :publisher
      t.text      :edition
      t.text      :category
      t.text      :subject
      t.string    :condition
      t.string    :isbn
      t.money     :price
      t.boolean   :in_shop
      t.integer   :consignor_id
      t.timestamp :consigned_date

      t.timestamps
    end
  end
end
