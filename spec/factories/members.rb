FactoryBot.define do
  factory :member do
    association :user
    association :room
  end
end
