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

require 'spec_helper'

describe Book do
  it { should belong_to(:consignor).class_name(User) }
end
