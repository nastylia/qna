module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user, only: [:up, :down, :unvote]
    before_action :set_votable, only: [:up, :down, :unvote]
    before_action :authorize, only: [:up, :down, :unvote]
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
        format.json { render json: { error: "Vote first" },
                             status: :forbidden }
      end
    end
  end

  private

  def authenticate_user
    authenticate_user!
  end

  def authorize
    authorize! params[:action].to_sym, @votable, user: current_user
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(value)
    respond_to do |format|
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
