module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:up, :down]
    before_action :set_votable, only: [:up, :down, :unvote]
    # after_action :respond_json, only: [:up, :down, :unvote]
  end

  def up
    @result = Vote.vote(votable: @votable, value: 1, current_user: current_user)
    respond_json
  end

  def down
    @result = Vote.vote(votable: @votable, value: -1, current_user: current_user)
    respond_json
  end

  def unvote
    @result = Vote.unvote(votable: @votable, current_user: current_user)
    respond_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def respond_json
    if @result
      respond_to do |format|
        format.json { render json: @result[:result], status: @result[:status] } if @result[:status]
        format.json { render json: @result[:result] } unless @result[:status]
      end
    end
  end

end
