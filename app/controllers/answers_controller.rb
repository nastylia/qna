class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer_and_question, only: [:destroy, :update, :mark_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_best
    if current_user.author_of?(@question)
      @question.answers.each do |a|
        a.update(best_answer: false)
      end
      @answer.update(best_answer: true)
    end
  end

  private

  def load_answer_and_question
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
