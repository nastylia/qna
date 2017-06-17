module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:up, :down]
  end

  def up
    respond_to do |format|
      if user_signed_in?
        if current_user.author_of?(@votable)
          format.json { render json: { error: "You are the author of the #{model_klass}. You cannot vote." }, status: :unauthorized }
        else
          set_vote
          @vote.update(value: 1)
          format.json { render json: @vote }
        end
      else
        format.json { render json: {}, status: :unauthorized }
      end
    end
  end

  def down
    respond_to do |format|
      if user_signed_in?
        if current_user.author_of?(@votable)
          format.json { render json: { error: "You are the author of the #{model_klass}. You cannot vote." }, status: :unauthorized }
        else
          set_vote
          @vote.update(value: -1)
          format.json { render json: @vote }
        end
      else
        format.json { render json: {}, status: :unauthorized }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    # binding.pry
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = Vote.where(user: current_user, votable_type: controller_name.classify, votable_id: params[:id]).first
    @vote = Vote.create(value: 0, user: current_user, votable_type: controller_name.classify, votable_id: params[:id]) if @vote.nil?
  end

end
