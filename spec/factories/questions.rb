FactoryGirl.define do

  sequence :title do |n|
    "Awesome title #{n}"
  end

  sequence :body do |n|
    "Test test #{n}"
  end

  factory :question_author, class: Question do
    title
    body
    association :author, factory: :user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

  factory :question, class: Question do
    title
    body
    association :author, factory: :user
  end

end
