module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:up, :down, :unvote]
    before_action :set_votable, only: [:up, :down, :unvote]
  end

  def up
    vote(1)
  end

  def down
    vote(-1)
  end

  def unvote
    vote = @votable.unvote(current_user: current_user)
    respond_to do |format|
      if vote
        format.json { render json: { votable_type: vote.votable_type,
                                         votable_id: vote.votable_id,
                                         result_votes: @votable.votes.sum(:value) } }
      else
        format.json { render json: { error: "You are the author of the #{@votable.class.name}. You cannot unvote." },
                             status: :forbidden }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(value)
    respond_to do |format|
      if current_user.author_of?(@votable)
        format.json { render json: { error: "You are the author of the #{@votable.class.name}. You cannot vote." },
                               status: :forbidden }
      else
        vote = @votable.vote(value: value, current_user: current_user)
        if vote
          format.json { render json: { votable_type: vote.votable_type,
                                         votable_id: vote.votable_id,
                                         result_votes: @votable.votes.sum(:value) } }
        else
          format.json { render json: { error: "Unvote first" },
                                 status: :forbidden }
        end
      end
    end
  end

end
