module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:up, :down, :unvote]
  end

  def up
    vote(1)
  end

  def down
    vote(-1)
  end

  def unvote
    set_vote
    if @vote
      @vote.delete if @vote
      respond_to do |format|
        format.json { render json: { votable_type: @vote.votable_type,
                                     votable_id: @vote.votable_id,
                                     result_votes: Vote.vote_result(@vote.votable_type, @vote.votable_id) } }
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

  def set_vote
    @vote = Vote.where(user: current_user, votable_type: controller_name.classify, votable_id: params[:id]).first
  end

  def vote(value)
    respond_to do |format|
      if user_signed_in?
        if current_user.author_of?(@votable)
          format.json { render json: { error: "You are the author of the #{model_klass}. You cannot vote." }, status: :unauthorized }
        else
          set_vote
          if @vote.nil?
            @vote = Vote.create(value: value, user: current_user, votable_type: controller_name.classify, votable_id: params[:id])
            format.json { render json: { votable_type: @vote.votable_type,
                                         votable_id: @vote.votable_id,
                                         result_votes: Vote.vote_result(@vote.votable_type, @vote.votable_id) } }
          else
            format.json { render json: { error: "Unvote first"}, status: :unauthorized }
          end
        end
      else
        format.json { render json: {}, status: :unauthorized }
      end
    end
  end

end
