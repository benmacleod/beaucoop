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
#  warned_at        :date
#

require 'spec_helper'

describe Book do
  it { should belong_to :user }
  it { should have_many :contacts }

  subject(:book) { Fabricate.build :book, expiry_date: expiry_date}
  let(:expiry_date) { nil }

  describe '#validate' do
    it_should_run_callbacks :expiry_under_six_months
  end

  describe '#before_save' do
    it_should_run_callbacks :populate_expiry_date
  end

  describe 'scopes' do
    let(:book) {
      Fabricate :book, user: owner, expiry_date: expiry_date, warned_at: warned_at
    }
    let(:owner) { Fabricate :user, admin: admin }
    let(:admin) { nil }
    let(:expiry_date) { 1.day.ago }
    let(:warned_at) { nil }
    before { book }
    describe '#nearly_aged' do
      subject(:nearly_aged) { Book.nearly_aged.first }
      context 'for a book owned by admin' do
        let(:admin) { true }
        it { should_not be_present }
      end

      context 'for a book not owned by admin' do
        let(:admin) { false }
        context 'where expiry date is within 1 month' do
          let(:expiry_date) { 3.weeks.since }
          context 'and the user was never warned about the book' do
            let(:warned_at) { nil }
            it { should be_present }
          end

          context 'and the user was warned about the book over a month ago' do
            let(:warned_at) { 2.months.ago }
            it { should be_present }
          end

          context 'and the user was warned about the book less than a month ago' do
            let(:warned_at) { 3.weeks.ago }
            it { should_not be_present }
          end
        end

        context 'where expiry date is greater than 1 month' do
          let(:expiry_date) { 2.months.since }
          it { should_not be_present }
        end
      end
    end

    describe '#aged' do
      subject(:aged) { Book.aged.first }
      context 'for a book owned by admin' do
        let(:admin) { true }
        it { should_not be_present }
      end

      context 'for a book not owned by admin' do
        let(:admin) { false }
        context 'whose expiry date is in the past' do
          let(:expiry_date) { 1.day.ago }
          it { should be_present }
        end

        context 'whose expiry date is in the future' do
          let(:expiry_date) { 1.day.since }
          it { should_not be_present }
        end
      end
    end
  end

  describe '#warn_aged' do
    let(:mail) { double Mail }
    let(:now) { Time.current }
    before do
      Time.stub current: now
    end

    it 'should send a mail to the user and update the warned_at timestamp to today' do
      book.should_receive(:update_attributes).with warned_at: now
      UserMailer.should_receive(:warn_aged).with(book).and_return mail
      mail.should_receive :deliver
      book.send :warn_aged
    end
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
