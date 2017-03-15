class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :title, :body, :author, presence: true
end
