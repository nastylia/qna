class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.create(comment: params[:comment][:comment], user: current_user)
    respond_to do |format|
      if @comment
        format.json { render json: {commentable_id: @comment[:commentable_id],
                                    commentable_type: @comment[:commentable_type],
                                    comment: @comment[:comment]}}
      end
    end
  end

  private

  def publish_comment
    # gon.commentable_type = commentable_name
    # gon.commentable_id = @commentable.id

    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments",
      {
        comment: @comment
      }
    )
  end

  def set_commentable
    id = params["#{params[:commentable]}_id"]
    @commentable = commentable_name.classify.constantize.find(id)
  end

  def commentable_name
    params[:commentable]
  end

end
