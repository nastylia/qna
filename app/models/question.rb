class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :title, :body, :author, presence: true

  accepts_nested_attributes_for :attachments
end
