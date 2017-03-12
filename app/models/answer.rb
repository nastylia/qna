class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  
  validates :body, :question, :author, presence: true

  scope :ordered, -> { order('answers.best_answer DESC') }

  def select_new_best_answer(answers)
    Answer.transaction do
      answers.update_all best_answer: false
      self.update(best_answer: true)
    end
  end
end
