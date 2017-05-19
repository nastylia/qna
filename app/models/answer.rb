class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :attachments, as: :attachable
  
  validates :body, :question, :author, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :ordered, -> { order('answers.best_answer DESC') }

  def select_new_best_answer(answers)
    Answer.transaction do
      answers.update_all best_answer: false
      self.update!(best_answer: true)
    end
  end
end
