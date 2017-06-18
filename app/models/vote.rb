class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  def self.vote(votable:, value:, current_user:)
    if current_user.author_of?(votable)
      return { result: { error: "You are the author of the #{votable.class.name}. You cannot vote." },
               status: :forbidden }
    else
      set_vote(votable, current_user)
      if @vote.nil?
        @vote = Vote.create(value: value, user: current_user, votable_type: votable.class.name, votable_id: votable.id)
        return { result: { votable_type: @vote.votable_type,
                           votable_id: @vote.votable_id,
                           result_votes: votable.votes.sum(:value) } }
      else
        return { result: { error: "Unvote first" },
                 status: :forbidden }
      end
    end
  end

  def self.unvote(votable:, current_user:)
    set_vote(votable, current_user)
    if @vote
      @vote.delete
      return { result: { votable_type: @vote.votable_type,
                         votable_id: @vote.votable_id,
                         result_votes: votable.votes.sum(:value) } }
    end
  end

  private

  def self.set_vote(votable, current_user)
    @vote = Vote.where(user: current_user, votable_type: votable.class.name, votable_id: votable.id).first
  end

end
