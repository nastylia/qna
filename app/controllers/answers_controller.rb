class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    unless @answer.save
      flash[:notice] = 'Answer was not saved'
      # render :"question/show"
      # render :template => 'questions/show'
    else
      redirect_to @question
    end
  end

  def destroy
    @question = @answer.question
    if User.author_of? current_user, @answer
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
