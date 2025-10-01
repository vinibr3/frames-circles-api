FactoryBot.define do
  factory :circle do
    frame { association(:frame) }
    x { Faker::Number.between(from: -10000.0, to: 10000.0).round(12) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0).round(12) }
    diameter { Faker::Number.positive.round(12) }
  end
end
