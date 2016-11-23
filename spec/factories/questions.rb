FactoryGirl.define do
  factory :invalid_question, class: Question do
    title nil
    body nil
  end

  factory :question do
    title "MyString"
    body "MyText"
  end
end
