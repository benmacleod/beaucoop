class AddThumbnailAndDescriptionToBooks < ActiveRecord::Migration
  def change
    add_column :books, :thumbnail, :text
    add_column :books, :description, :text
  end
end
