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
      t.money     :price, allow_nil: true
      t.boolean   :in_shop
      t.integer   :consignor_id
      t.date :consigned_date

      t.timestamps
    end
  end
end
