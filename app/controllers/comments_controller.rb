class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :build_comment

  after_action :publish_comment, only: [:create]

  respond_to :json

  authorize_resource

  def create
    respond_with(@comment, location: @commentable)
  end

  private

  def publish_comment

    return if @comment.errors.any?
    question_id = @comment.commentable_type == 'Question' ? @comment.commentable.id : @comment.commentable.question.id

    ActionCable.server.broadcast(
      "question_#{question_id}/comments",
      {
        comment: @comment
      }
    )
  end

  def build_comment
    @comment = @commentable.comments.create(comment: params[:comment][:comment], user: current_user)
  end

  def set_commentable
    id = params["#{params[:commentable]}_id"]
    @commentable = commentable_name.classify.constantize.find(id)
  end

  def commentable_name
    params[:commentable]
  end

end
