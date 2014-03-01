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

Fabricator(:contact) do
  book
  contact_details 'Find me at Joe\'s'
end
