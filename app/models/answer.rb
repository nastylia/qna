class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  
  validates :body, :question, :author, presence: true

  scope :ordered, -> { order('answers.best_answer DESC') }
end
