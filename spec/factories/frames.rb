FactoryBot.define do
  factory :frame do
    x { Faker::Number.between(from: -10000.0, to: 10000.0).round(3) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0).round(3) }
    width { Faker::Number.positive.round(3) }
    height { Faker::Number.positive.round(3) }
  end
end
