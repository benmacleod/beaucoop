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

$seed ||= Random.new(123)

Fabricator :user do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  email { |attrs|
    Faker::Internet.email"#{attrs[:first_name]} #{attrs[:last_name]}"
  }
  phone_number { '04%08d' % $seed.rand(99_999_999) }
  password 'password'
end

Fabricator :admin, from: :user do
  admin true
end
