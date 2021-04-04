FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'email@email.com' }
    password { 'password' }
  end
end