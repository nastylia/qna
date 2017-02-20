FactoryGirl.define do

  # sequence :body  do |n|
  #   "Awesome answer #{n}"
  # end

  factory :answer do
    body
    question

    # factory :answer_with_question do
    #   after(:create) do |answer|
    #     answer.question << :question
    #   end
    # end

  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
