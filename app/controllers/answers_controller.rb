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
    params.require(:answer).permit(:body)
  end
end
