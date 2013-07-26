class Book < ActiveRecord::Base
  belongs_to :consignor, class_name: User, foreign_key: :consignor_id
end
