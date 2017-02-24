require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_author, author: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user :user
      it 'saves new answer in db' do
        expect { post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'saves new answer under our question' do
        expect { post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer, author_id: user.id), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      sign_in_user :user
      it 'does not save an answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
      it 're-directs to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end

  describe 'delete #destroy' do
    let(:answer) { create(:answer, question: question, author: user) }
    sign_in_user :user
    it 'deletes answer' do
      answer
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it 'redirect to qustion show view' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
end