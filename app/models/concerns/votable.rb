module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all

    def sum_votes
      self.votes.sum(:value)
    end

    def vote(value:, current_user: )
      set_vote(current_user)
      if @vote.nil?
        @vote = Vote.create(value: value, user: current_user, votable_type: self.class.name, votable_id: self.id)
        return @vote
      end
    end

    def unvote(current_user:)
      set_vote(current_user)
      if @vote
        @vote.delete
        return @vote
      end
    end

    private

    def set_vote(current_user)
      @vote = Vote.where(user: current_user, votable_type: self.class.name, votable_id: self.id).first
    end
  end
end
