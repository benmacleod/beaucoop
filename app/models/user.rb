class User < ActiveRecord::Base
  has_many :consigned_books, class_name: Book, foreign_key: :consignor_id
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
