class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:destroy]
  def index
    @answers = Answer.where(question_id: params[:question_id])
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(@answer.question_id)
    @answer.destroy
    flash[:notice] = 'Answer was successfully deleted'
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
