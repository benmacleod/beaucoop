class ContactMailer < ActionMailer::Base
  default from: 'umsubookcoop@gmail.com'

  def contact_seller(contact)
    @contact = contact
    params = {
        to: contact.book.user.email,
        subject: "UMSU Book Coop - Enquiry about your book #{contact.book.title}"
    }
    params[:reply_to] = contact.user.email if contact.user
    mail params
  end
end
