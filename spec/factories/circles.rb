FactoryBot.define do
  factory :circle do
    frame { association(:frame) }
    x { Faker::Number.between(from: -10000.0, to: 10000.0).round(3) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0).round(3) }
    diameter { Faker::Number.positive.round(3) }
  end
end
