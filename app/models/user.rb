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

class User < ActiveRecord::Base
  has_many :books
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable
  validates :contact_details, presence: { unless: ->(u){ u.direct_email? or u.admin? } }
end
