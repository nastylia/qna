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
      it 'renders create view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: 'js'
        expect(response).to render_template :create
      end
    end
  end

  describe 'delete #destroy' do
    context 'signed in user is an author' do
      let(:answer) { create(:answer, question: question, author: @user) }
      sign_in_user
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, format: 'js' }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, format: 'js'
        expect(response).to render_template :destroy
      end
    end

    context 'signed in user is not an author' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, author: user) }
      sign_in_user
      it 'cannot delete answer' do
        answer
        expect { delete :destroy, id: answer, format: 'js' }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, format: 'js'
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'patch #update' do
    context 'signed in user is an author' do
      context 'valid attributes' do
        let(:answer) { create(:answer, question: question, author: @user) }
        sign_in_user
        it 'assigns requested answer to @answer' do
          patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: 'js'
          expect(assigns(:answer)).to eq answer
        end

        it 'assigns the question' do
          patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: 'js'
          expect(assigns(:question)).to eq question
        end

        it 'changes answer attributes' do
          patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: 'js'
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: 'js'
          expect(response).to render_template :update
        end
      end

      context 'invalid attributes' do
        let(:answer) { create(:answer, question: question, author: @user) }
        sign_in_user
        it 'doesn\'t change answer attributes' do
          patch :update, id: answer, question_id: question, answer: { body: '' }, format: 'js'
          answer.reload
          expect(answer.body).to_not eq ''
        end

        it 'renders update view' do
          patch :update, id: answer, question_id: question, answer: { body: '' }, format: 'js'
          expect(response).to render_template :update
        end
      end
    end

    context 'signed in user is not an author' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, author: user) }
      sign_in_user
      it 'cannto edit answer' do
        answer
        old_body = answer.body
        patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: 'js'
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'renders update view' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: 'js'
        expect(response).to render_template :update
      end
    end
  end

  describe 'patch #mark_best' do
    let(:user1) { create(:user) }
    let(:question1) { create(:question_author, author: user1) }
    sign_in_user
    context 'authenticated user is question author' do
      let(:answers) { create_list(:answer, 3, question: question, author: user1) }
      it 'marks answer as the best' do
        patch :mark_best, id: answers[0], format: 'js'
        answers[0].reload
        expect(answers[0].best_answer).to eq true
      end

      it 'de-marks previous best answer, when another best answer is selected' do
        patch :mark_best, id: answers[0], format: 'js'
        patch :mark_best, id: answers[1], format: 'js'
        answers.each { |a| a.reload }
        expect(answers[0].best_answer).to eq false
        expect(answers[1].best_answer).to eq true
      end

      it 'renders mark_best template' do
        patch :mark_best, id: answers[0], format: 'js'
        answers[0].reload
        expect(response).to render_template :mark_best
      end
    end

    context 'authenticated user is not question author' do
      let(:answer) { create(:answer, question: question1, author: user1) }
      sign_in_user
      it 'cannot select best answer' do
        patch :mark_best, id: answer, format: 'js'
        answer.reload
        expect(answer.best_answer).to eq false
      end

      it 'renders mark_best template' do
        patch :mark_best, id: answer, format: 'js'
        answer.reload
        expect(response).to render_template :mark_best
      end
    end

  end
end