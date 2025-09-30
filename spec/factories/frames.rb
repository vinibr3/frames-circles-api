FactoryBot.define do
  factory :frame do
    x { Faker::Number.between(from: -10000.0, to: 10000.0) }
    y { Faker::Number.between(from: -10000.0, to: 10000.0) }
    width { Faker::Number.positive }
    height { Faker::Number.positive }
  end
end
