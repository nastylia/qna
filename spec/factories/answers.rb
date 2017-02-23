FactoryGirl.define do

  factory :answer do
    body
    question
    association author, factory: :user
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
