require 'spec_helper'

describe UserMailer do
  describe '#contact_seller' do
    let(:mail) { UserMailer.warn_aged book }
    let(:book) { Fabricate.build :book, id: 123, user: owner, title: Faker::Lorem.sentence }
    let(:owner) { Fabricate.build :user, email: Faker::Internet.email }

    it 'should generate a mail to the owner, telling them the buyer is interested in their book' do
      mail.subject.should == "UMSU Book Coop - Your book #{book.title} will expire soon"
      mail.to.should == [owner.email]
      mail.from.should == ['umsubookcoop@gmail.com']
      mail.body.encoded.should have_tag :p,
          text: 'The book you have advertised for sale through UMSU Book Coop will expire in a month. If you wish to keep advertising on the UMSU catalogue, please go here and extend its expiry date.'
      mail.body.encoded.should have_tag :a, text: 'here', with: {href: book_url(book)}
    end
  end
end
