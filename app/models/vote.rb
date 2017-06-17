class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  scope :vote_result, ->(type, id) { where(votable_type: type, votable_id: id).pluck(:value).inject(0, :+) }
end
