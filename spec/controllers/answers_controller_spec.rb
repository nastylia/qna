require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question) }

    before { get :index, question_id: question }

    it 'populates an array of all answers for a question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question} }.to change(Answer, :count).by(1)
        assert_equal assigns(:answer).question_id, question.id
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question}
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question} }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question}
        expect(response).to render_template :new
      end
    end
  end
end
