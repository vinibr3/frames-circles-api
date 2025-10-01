FactoryBot.define do
  factory :frame do
    x { Faker::Number.between(from: -10000.0, to: 10000.0).round(12) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0).round(12) }
    width { Faker::Number.positive.round(12) }
    height { Faker::Number.positive.round(12) }
  end
end
