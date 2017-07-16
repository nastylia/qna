class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer_and_question, only: [:destroy, :update, :mark_best]

  before_action :authorize_mark_best, only: [:mark_best]

  before_action :build_answer, only: [:create]

  after_action :publish_answer, only: [:create]

  authorize_resource

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

  def authorize_mark_best
    authorize! :mark_best, @answer, user: current_user
  end

  def build_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
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
