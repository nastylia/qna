FactoryGirl.define do
  sequence :comment do |n|
    "uawesome comment #{n}"
  end

  factory :my_comment, class: Comment do
    comment
    user
    trait :question do
      association :commentable, factory: :question
      commentable_type 'Question'
    end
    trait :answer do
      association :commentable, factory: :answer
      commentable_type 'Answer'
    end
  end
end
