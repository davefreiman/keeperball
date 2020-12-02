FactoryBot.define do
  factory :user do
    email { "dave@freiman.co" }
    password { "test" }
    admin { false }
  end
end
