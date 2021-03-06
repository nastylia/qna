class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :build_question, only: [:create]
  before_action :build_answers, only: [:show]
  before_action :set_gon, only: [:show, :create]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) do |format|
      format.js { redirect_to questions_path }
    end
  end

  private

  def set_gon
    gon.question_id = @question.id
  end

  def build_question
    @question = current_user.questions.create(question_params)
  end

  def build_answers
    @answers = @question.answers
    @answer = @question.answers.build
  end

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
