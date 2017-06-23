class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new(question_id: @question.id)
    @answer.attachments.build
    gon.question_id = @question.id
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
    gon.question_id = @question.id
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

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => request.env["warden"]})
    ActionCable.server.broadcast(
      'questions',
      renderer.render(
        locals: { question: @question },
        partial: 'questions/question_info'
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
