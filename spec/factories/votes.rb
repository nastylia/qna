FactoryGirl.define do
  factory :vote do
    user
    trait :answer do
      association :votable, factory: :answer
    end
    trait :question do
      association :votable, factory: :question
    end
    value 0
  end
end
