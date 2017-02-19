FactoryGirl.define do

  sequence :title do |n|
    "Awesome title #{n}"
  end

  sequence :body do |n|
    "Test test #{n}"
  end

  factory :questions, class: Question do
    title
    body
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

  factory :question do
    title "MyString"
    body "MyText"
  end
end
