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
#

require 'spec_helper'

describe User do
  it { should have_many :books }

  describe 'abilities' do
    require 'cancan/matchers'

    subject(:ability) { Ability.new user }

    context 'as an admin' do
      let(:user) { Fabricate :admin }
      it { should be_able_to(:manage, Book.new) }
    end

    context 'as a standard user' do
      let(:user) { Fabricate :user }
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
