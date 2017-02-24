class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    unless @answer.save
      flash[:notice] = 'Answer was not saved'
    end
    redirect_to @question
  end

  def destroy
    # binding.pry
    @question = @answer.question
    if user_signed_in? && current_user.id == @answer.author_id
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:notice] = 'You are not authorized to delete question'
    end
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id)
  end
end
