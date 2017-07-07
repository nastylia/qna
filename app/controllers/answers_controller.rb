class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer_and_question, only: [:destroy, :update, :mark_best]
  before_action :is_answer_author?, only: [:update, :destroy]
  before_action :is_question_author?, only: [:mark_best]
  before_action :build_answer, only: [:create]

  after_action :publish_answer, only: [:create]
  def create
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def mark_best
    @answer.select_new_best_answer(@question.answers)
    respond_with @answer
  end

  private

  def build_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def is_question_author?
    is_author?(item: @question)
  end

  def is_answer_author?
    is_author?(item: @answer)
  end

  def is_author?(item:)
    respond_with(@answer) do |format|
      flash[:notice] = 'You are not authorized to perform this action'
      format.js { head :forbidden }
    end unless current_user.author_of?(item)
  end

  def load_answer_and_question
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def publish_answer
    return if @answer.errors.any?
    attachments = []
    @answer.attachments.each do |a|
      attachment = {}
      attachment[:id] = a.id
      attachment[:url] = a.file.url
      attachment[:name] = a.file.identifier
      attachments << attachment
    end
    ActionCable.server.broadcast(
      "question_#{@question.id}/answers",
      {
        answer: @answer,
        attachments: attachments,
        rating: @answer.sum_votes,
        question: @question
      }
    )
  end
end
