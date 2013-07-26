Fabricator :user do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  email { |attrs|
    Faker::Internet.email"#{attrs[:first_name]} #{attrs[:last_name]}"
  }
  password 'password'
end

Fabricator :admin, from: :user do
  admin true
end
