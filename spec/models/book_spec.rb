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

require 'spec_helper'

describe Book do
  it { should belong_to(:consignor).class_name(User) }
end
