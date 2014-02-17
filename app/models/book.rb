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
#  user_id          :integer
#  consignment_date :date
#  created_at       :datetime
#  updated_at       :datetime
#  checked          :boolean
#  genre            :string(255)
#  consignee        :text
#  thumbnail        :text
#  description      :text
#  price_negotiable :boolean
#  expiry_date      :date
#

class Book < ActiveRecord::Base
  belongs_to :user
  monetize :price_cents, allow_nil: true
  register_currency :aud
  scope :expired_consignments, -> { where 'consignment_date < ?', 6.months.ago }
  validate :expiry_under_six_months
  before_save :populate_expiry_date
  
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
    consignment_date && consignment_date < 6.months.ago
  end

  private
  def populate_expiry_date
    self.expiry_date ||= 6.months.since
  end

  def expiry_under_six_months
    if (self.expiry_date || Time.current) > 6.months.since
      self.errors.add :expiry_date, 'must be less than 6 months away'
    end
  end
end
