class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best_answer, :question_id, :created_at, :updated_at, :author_id
  has_many :comments
  has_many :attachments
end
