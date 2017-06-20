FactoryGirl.define do
  factory :vote do
    user
    value 1
    trait :answer do
      association :votable, factory: :answer
    end
    trait :question do
      association :votable, factory: :question
    end
  end
end
