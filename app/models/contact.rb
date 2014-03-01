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

class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  validates :book, presence: true
  validate :ensure_contactability
  after_create :send_email

  private
  def send_email
    ContactMailer.contact_seller(self).deliver
  end

  def ensure_contactability
    if user.blank? and contact_details.blank?
      self.errors[:contact_details] << 'if you are not logged in as a user, you will need to provide some contact details for the book\'s seller to get in touch with you'
    end
  end
end
