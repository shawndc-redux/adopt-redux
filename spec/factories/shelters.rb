FactoryBot.define do
  factory :shelter do
    name {Faker::Space.galaxy}
    city {"Chicago, IL"}
    foster_program {true}
    rank {9}
  end
end