class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]
  
  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new(question_id: @question.id)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.author_id = current_user.id
    if @question.save
      flash[:notice] = 'Your question was successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = 'Question was successfully deleted'
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id)
  end
end
