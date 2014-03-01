# == Schema Information
#
# Table name: contacts
#
#  id              :integer          not null, primary key
#  book_id         :integer
#  user_id         :integer
#  contact_details :text
#  message         :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Contact do
  it { should belong_to :book }
  it { should belong_to :user }
  it { should validate_presence_of :book }

  describe '#validate' do
    it_should_run_callbacks :ensure_contactability
  end

  describe '#after_create' do
    it_should_run_callbacks :send_email
  end

  describe '#send_email' do
    let(:contact) { Fabricate.build :contact }
    let(:mail) { double Mail }
    it 'should pass itself to the ContactMailer and deliver an email' do
      ContactMailer.should_receive(:contact_seller).with(contact).and_return mail
      mail.should_receive :deliver
      contact.send :send_email
    end
  end

  describe '#ensure_contactability' do
    subject(:contact) {
      Fabricate.build :contact, user: user, contact_details: contact_details
    }
    
    context 'where #user is blank' do
      let(:user) { nil }
      context 'and #contact_details is present' do
        let(:contact_details) { '1 Blah Street' }
        it 'should do nothing' do
          contact.send :ensure_contactability
          contact.errors.should be_blank
        end
      end

      context 'and #contact_details is blank' do
        let(:contact_details) { nil }
        it 'should add errors to contact_details' do
          contact.send :ensure_contactability
          contact.errors[:contact_details].should include 'if you are not logged in as a user, you will need to provide some contact details for the book\'s seller to get in touch with you'
        end
      end

      context 'where #user is present' do
        let(:user) { Fabricate.build :user }
        let(:contact_details) { nil }
        it 'should do nothing' do
          contact.send :ensure_contactability
          contact.errors.should be_blank
        end
      end
    end
  end
end
