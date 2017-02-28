require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_author, author: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      it 'saves new answer under our question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: 'js' }.to change(question.answers, :count).by(1)
      end

      it 'saves new answer under logged in user' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: 'js' }.to change(@user.answers, :count).by(1)
      end

      it 'renders create view' do
        post :create, answer: attributes_for(:answer), question_id: question, format: 'js'
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      it 'does not save an answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: 'js' }.to_not change(Answer, :count)
      end
      it 're-directs to question show view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: 'js'
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'delete #destroy' do
    context 'signed in user is an author' do
      let(:answer) { create(:answer, question: question, author: @user) }
      sign_in_user
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end
      it 'redirects to question show view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'signed in user is not an author' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, author: user) }
      sign_in_user
      it 'cannot delete answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end
      it 'redirects to question show view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end