FactoryBot.define do
  factory :pet do
    adoptable {true}
    age {Faker::Number.between(from: 1, to: 10)}
    name { Faker::Creature::Cat.name}
    breed { Faker::Creature::Cat.breed}
    association :shelter
  end
end