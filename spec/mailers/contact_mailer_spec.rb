require 'spec_helper'

describe ContactMailer do
  describe '#contact_seller' do
    let(:mail) { ContactMailer.contact_seller contact }
    let(:contact) {
      Fabricate.build :contact, id: 123, book: book, user: user, message: message,
                      contact_details: contact_details
    }
    let(:contact_details) { nil }
    let(:message) { nil }
    let(:book) { Fabricate.build :book, user: owner, title: Faker::Lorem.sentence }
    let(:owner) { Fabricate.build :user, email: Faker::Internet.email }

    shared_examples_for 'all contact seller emails' do
      it 'should generate a mail to the owner, telling them the buyer is interested in their book' do
        mail.subject.should == "UMSU Book Coop - Enquiry about your book #{book.title}"
        mail.to.should == [owner.email]
        mail.from.should == ['umsubookcoop@gmail.com']
        mail.body.encoded.should have_tag :p,
            text: 'You have received an enquiry about your book from a potential buyer.'
        mail.body.encoded.should have_tag :p,
            text: 'The current details you have listed for the book are here. If the book is no longer for sale, please consider visiting this link and deleting it from the Book Coop system.'
        mail.body.encoded.should have_tag :a, text: 'here', with: {href: book_url(book)}
      end

      context 'where there is a message in the contact' do
        let(:message) { Faker::Lorem.sentence }
        it 'should show the message' do
          mail.body.encoded.should have_tag :p,
              text: 'They included the following message to you:'
          mail.body.encoded.should have_tag :p, text: message
        end
      end

      context 'where there is no message in the contact' do
        let(:message) { nil }
        it 'should show the message' do
          mail.body.encoded.should_not have_tag :p,
              text: 'They included the following message to you:'
        end
      end
    end

    shared_examples_for 'contact has no reply email' do
      it_should_behave_like 'all contact seller emails'
      it 'should show extra contact details ' do
        mail.reply_to.should be_blank
        mail.body.encoded.should have_tag :p,
            text: 'They have given us the following contact details to enable you to get in touch with them. Please use these details instead of replying to this email:'
        mail.body.encoded.should have_tag :p,
            text: 'facebook.com/dodgybloke'
      end
    end

    context 'where the contact has a user' do
      let(:user) { Fabricate.build :user, email: user_email, contact_details: user_contact_details }
      let(:user_email) { nil }
      let(:user_contact_details) { nil }
      context 'and the user has an email' do
        let(:user_email) { Faker::Internet.email }
        it_should_behave_like 'all contact seller emails'
        it 'should have a reply to address for the user, and no extra contact details' do
          mail.reply_to.should == [user.email]
          mail.body.encoded.should have_tag :p,
              text: 'In order to reply to them, simply reply to this email.'
        end
      end

      context 'and the user has no email' do
        let(:user_contact_details) { 'facebook.com/dodgybloke' }
        it_should_behave_like 'contact has no reply email'
      end
    end

    context 'where the contact has no user, but has contact details' do
      let(:user) { nil }
      let(:contact_details) { 'facebook.com/dodgybloke' }
      it_should_behave_like 'contact has no reply email'
    end
  end
end
