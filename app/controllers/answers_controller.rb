class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    unless @answer.save
      @question.reload
      flash[:notice] = 'Answer was not saved'
      # render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    if user_signed_in? && current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:notice] = 'You are not authorized to delete answer'
    end
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
