FactoryGirl.define do
  sequence :comment do |n|
    "uawesome comment #{n}"
  end

  factory :question_comment, class: Comment do

  end
end
