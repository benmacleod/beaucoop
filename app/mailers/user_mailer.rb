class UserMailer < ActionMailer::Base
  default from: 'umsubookcoop@gmail.com'

  def warn_aged(book)
    @book = book
    mail to: book.user.email, subject: "UMSU Book Coop - Your book #{book.title} will expire soon"
  end
end
