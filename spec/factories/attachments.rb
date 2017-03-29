FactoryGirl.define do

  factory :attachment do
    file { File.new("#{Rails.root}/spec/test_files/test1") }
    trait :question do
      association :attachable, factory: :question
    end
    trait :answer do
      association :attachable, factory: :answer
    end
  end
end
