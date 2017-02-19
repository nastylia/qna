class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def index
    @answers = Answer.where(question_id: params[:question_id])
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
