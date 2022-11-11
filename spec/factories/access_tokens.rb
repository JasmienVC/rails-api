FactoryBot.define do
  factory :access_token do
    token { '123' }
    user { create :user }
  end
end
