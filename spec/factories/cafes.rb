FactoryBot.define do
  factory :cafe do
    title { Faker::Coffee.blend_name }
    address { Faker::Address.street_address }
    picture { nil }
    hours { { monday: "9:00-17:00", tuesday: "9:00-17:00" } }
    criteria { %w[cozy wifi pet-friendly] }
  end
end