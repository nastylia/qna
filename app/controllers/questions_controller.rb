class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :set_votes, only: [:show]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new(question_id: @question.id)
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      head :forbidden
    end
  end

  def destroy
    if user_signed_in? && current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question was successfully deleted'
    else
      flash[:notice] = 'You are not authorized to delete question'
    end
    redirect_to questions_path
  end

  private

  def set_votes
    # binding.pry
    @question.result_votes = Vote.vote_result('Question', @question.id)
    # return if @question.answers.nil?
    @question.answers.each do |answer|
      answer.result_votes = Vote.vote_result('Answer', answer.id)
      answer.save!
    end
    @question.save!
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
