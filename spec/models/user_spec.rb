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
  it { should have_many(:consigned_books).class_name(Book) }

  describe 'abilities' do
    require 'cancan/matchers'

    subject(:ability) { Ability.new user }
    let(:user) { nil }

    context 'as an admin' do
      let(:user) { Fabricate :admin }
      it { should be_able_to(:manage, Book.new) }
    end

    context 'as an standard user' do
      it { should be_able_to(:read, Book.new) }
      it { should_not be_able_to(:create, Book.new) }
      it { should_not be_able_to(:delete, Book.new) }
      it { should_not be_able_to(:update, Book.new) }
    end
  end
end
