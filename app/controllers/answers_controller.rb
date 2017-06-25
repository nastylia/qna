class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer_and_question, only: [:destroy, :update, :mark_best]

  after_action :publish_answer, only: [:create]
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      head :forbidden
    end
  end

  def mark_best
    if current_user.author_of?(@question)
      @answer.select_new_best_answer(@question.answers)
    else
      head :forbidden
    end
  end

  private

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
