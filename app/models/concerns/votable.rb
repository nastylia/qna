module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end
end
