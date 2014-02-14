# == Schema Information
#
# Table name: books
#
#  id               :integer          not null, primary key
#  title            :text
#  author           :text
#  publisher        :text
#  edition          :text
#  category         :text
#  subject          :text
#  condition        :string(255)
#  isbn             :string(255)
#  price_cents      :integer          default(0), not null
#  price_currency   :string(255)      default("AUD"), not null
#  in_shop          :boolean
#  user_id          :integer
#  consignment_date :date
#  created_at       :datetime
#  updated_at       :datetime
#  checked          :boolean
#  genre            :string(255)
#  consignee        :text
#  thumbnail        :text
#  description      :text
#  price_negotiable :boolean
#

Fabricator :book do
  title     { Faker::Lorem.sentence }
  author    { Faker::Name.last_name }
  publisher { Faker::Company.name }
  edition   { "#{Faker::Lorem.word} Edition" }
  category  { [
        'Law',
        'IT',
        'Fiction',
        'Classic Fiction',
        'Science and Engineering',
        'Maths',
        'Management',
        'Marketing, Finance, Economics',
        'Language and Linguistics',
        'Education',
        'Plays',
        'Political & Social Sciences',
        'Food & Health',
        'Biography & Travel',
    ].sample
  }
  subject        { Faker::Lorem.word }
  condition      { %w(excellent good fair poor).sample }
  isbn           { '%09d' % rand(999_999_999) }
  consignment_date {
    from = 1.year.ago
    Time.at(from + rand * (Time.now.to_f - from.to_f))
  }
  price_cents { rand(10_000) }
  in_shop { [true, false].sample }
end
