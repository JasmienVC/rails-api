FactoryBot.define do
  sequence :token do |n|
    "token-#{n}"
  end

  factory :access_token do
    token
    user { create :user }
  end
end
