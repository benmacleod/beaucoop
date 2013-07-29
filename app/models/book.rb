# == Schema Information
#
# Table name: books
#
#  id             :integer          not null, primary key
#  title          :text
#  author         :text
#  publisher      :text
#  edition        :text
#  category       :text
#  subject        :text
#  condition      :string(255)
#  isbn           :string(255)
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  in_shop        :boolean
#  consignor_id   :integer
#  consigned_date :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class Book < ActiveRecord::Base
  belongs_to :consignor, class_name: User, foreign_key: :consignor_id
  accepts_nested_attributes_for :consignor
  monetize :price_cents, allow_nil: true
  register_currency :aud
end
