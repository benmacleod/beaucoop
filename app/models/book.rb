# == Schema Information
#
# Table name: books
#
#  id               :integer          not null, primary key
#  title            :text
#  author           :text
#  publisher        :text
#  edition          :text
#  category         :text
#  subject          :text
#  condition        :string(255)
#  isbn             :string(255)
#  price_cents      :integer          default(0), not null
#  price_currency   :string(255)      default("AUD"), not null
#  in_shop          :boolean
#  consignor_id     :integer
#  consignment_date :date
#  created_at       :datetime
#  updated_at       :datetime
#  checked          :boolean
#  genre            :string(255)
#  consignee        :text
#  thumbnail        :text
#  description      :text
#

class Book < ActiveRecord::Base
  belongs_to :consignor, class_name: User, foreign_key: :consignor_id
  accepts_nested_attributes_for :consignor
  monetize :price_cents, allow_nil: true
  register_currency :aud
  scope :expired_consignments, -> { where 'consignment_date < ?', 6.months.ago }

  def self.search(params)
    relation = self.scoped
    params.each do |key, value|
      unless value.blank?
        relation = relation.where("#{key} LIKE ?", "%#{value}%")
      end
    end
    relation
  end

  def expired_consignment?
    consignment_date < 6.months.ago
  end
end
