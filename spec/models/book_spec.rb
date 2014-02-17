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

require 'spec_helper'

describe Book do
  it { should belong_to(:user) }

  subject(:book) { Fabricate.build :book, expiry_date: expiry_date}
  let(:expiry_date) { nil }

  describe '#validate' do
    it_should_run_callbacks :expiry_under_six_months
  end

  describe '#before_save' do
    it_should_run_callbacks :populate_expiry_date
  end

  describe '#populate_expiry_date' do
    subject(:populated) {
      book.send(:populate_expiry_date)
      book.expiry_date
    }
    context 'where expiry date is empty' do
      let(:expiry_date) { nil }
      it 'should set it to 6 months from now' do
        should == 6.months.since.to_date
      end
    end

    context 'where expiry date is not empty' do
      let(:expiry_date) { 1.days.since }
      it 'it should do nothing' do
        should == 1.days.since.to_date
      end
    end
  end

  describe '#expiry_under_six_months' do
    context 'where #expiry_date is blank' do
      let(:expiry_date) { nil }
      it 'should do nothing' do
        book.send :expiry_under_six_months
        book.errors.should be_blank
      end
    end

    context 'where #expiry_date is less than 6 months away' do
      let(:expiry_date) { 5.months.since }
      it 'should do nothing' do
        book.send :expiry_under_six_months
        book.errors.should be_blank
      end
    end

    context 'where #expiry_date is less than 6 months away' do
      let(:expiry_date) { 7.months.since }
      it 'should do nothing' do
        book.send :expiry_under_six_months
        book.errors[:expiry_date].should include 'must be less than 6 months away'
      end
    end
  end
end
