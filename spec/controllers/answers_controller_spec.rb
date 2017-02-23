require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_author, author: user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question, author: user) }

    before { get :index, question_id: question }

    it 'populates an array of all answers for a question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
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
      sign_in_user
      it 'saves new answer in db' do
        expect { post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'saves new answer under our question' do
        expect { post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      it 'does not save an answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'delete #destroy' do
    let(:answer) { create(:answer, question: question, author: user) }
    sign_in_user
    it 'deletes answer' do
      answer
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
end