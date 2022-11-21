FactoryBot.define do
  factory :comment do
    content { "MyText" }
    article { nil }
    user { nil }
  end
end
