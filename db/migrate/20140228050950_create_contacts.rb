class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :book_id
      t.integer :user_id
      t.text :contact_details
      t.text :message
      t.timestamps
    end
  end
end
