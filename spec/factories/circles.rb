FactoryBot.define do
  factory :circle do
    frame { association(:frame) }
    x { Faker::Number.between(from: -10000.0, to: 10000.0) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0) }
    diameter { Faker::Number.positive }
  end
end
