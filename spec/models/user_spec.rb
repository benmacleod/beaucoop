# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :text
#  last_name              :text
#  phone_number           :text
#  admin                  :boolean
#  created_at             :datetime
#  updated_at             :datetime
#  direct_email           :boolean
#  contact_details        :text
#

require 'spec_helper'

describe User do
  subject(:user) { Fabricate.build :user, direct_email: direct_email }
  let(:direct_email) { true }
  it { should have_many :books }

  describe '#contact_details' do
    context 'when user is an admin' do
      subject(:user) { Fabricate.build :admin }
      it { should_not validate_presence_of :contact_details }
    end
    context 'when direct_email is true' do
      let(:direct_email) { true }
      it { should_not validate_presence_of :contact_details }
    end

    context 'when direct_email is false' do
      let(:direct_email) { false }
      it { should validate_presence_of :contact_details }
    end
  end

  describe 'abilities' do
    require 'cancan/matchers'

    subject(:ability) { Ability.new user }

    context 'as an admin' do
      let(:user) { Fabricate :admin }
      it { should be_able_to(:manage, Book.new) }
    end

    context 'as a standard user' do
      context 'for books they own' do
        let(:book) { Fabricate :book, user: user }
        it { should be_able_to(:manage, book) }
      end
      context "for books they don't own" do
        let(:book) { Book.new }
        it { should be_able_to(:read, book) }
        it { should_not be_able_to(:create, book) }
        it { should_not be_able_to(:delete, book) }
        it { should_not be_able_to(:update, book) }
      end
    end

    context 'as a guest' do
      let(:user) { nil }
      it { should be_able_to(:read, Book.new) }
      it { should_not be_able_to(:create, Book.new) }
      it { should_not be_able_to(:delete, Book.new) }
      it { should_not be_able_to(:update, Book.new) }
    end
  end
end
