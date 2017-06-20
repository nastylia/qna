module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def sum_votes
    self.votes.sum(:value)
  end

  def vote(value:, current_user: )
    set_vote(current_user)
    if @vote.nil?
      self.votes.create(user: current_user, value: value)
    end
  end

  def unvote(current_user:)
    set_vote(current_user)
    if @vote
      @vote.destroy
    end
  end

  private

  def set_vote(current_user)
    @vote = self.votes.where(user: current_user).first
  end

end
