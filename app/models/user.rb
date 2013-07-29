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

class User < ActiveRecord::Base
  has_many :consigned_books, class_name: Book, foreign_key: :consignor_id
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
