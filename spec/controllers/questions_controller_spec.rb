require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_author, author: @user) }
  describe 'GET #index' do
    let(:questions) { create_list(:question_author, 2, author: user) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question_author, author: user) }
    
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      get :show, id: question
      expect(assigns(:question)).to eq question
    end

    it 'renders show views' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user
      it 'saves new question in the db' do
        expect { post :create, params: { question: attributes_for(:question_author) } }.to change(Question, :count).by(1)
      end
      it 'saves new question under logged in user' do
        expect { post :create, params: { question: attributes_for(:question_author) } }.to change(@user.questions, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question_author) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'signed in user is an author' do
      sign_in_user
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'signed in user is not an author' do
      let(:question) { create(:question, author: user) }
      sign_in_user
      it 'cannot delete question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'signed in user is an author' do
      context 'valid attributes' do
        sign_in_user
        it 'assigns requested question to @question' do
          patch :update, id: question, question: attributes_for(:question), format: 'js'
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, id: question, question: { title: 'edited title', body: 'edited body' }, format: 'js'
          question.reload
          expect(question.title).to eq 'edited title'
          expect(question.body).to eq 'edited body'
        end

        it 'renders update view' do
          patch :update, id: question, question: attributes_for(:question), format: 'js'
          expect(response).to render_template :update
        end
      end

      context 'invalid attributes' do
        sign_in_user
        it 'doesn\'t change question attributes' do
          patch :update, id: question, question: { title: '', body: '' }, format: 'js'
          question.reload
          expect(question.body).to_not eq ''
          expect(question.title).to_not eq ''
        end

        it 'renders update view' do
          patch :update, id: question, question: { title: '', body: '' }, format: 'js'
          expect(response).to render_template :update
        end
      end
    end

    context 'signed in user is not an author' do
      let(:user1) { create(:user) }
      let(:question1) { create(:question_author, author: user1) }
      sign_in_user
      it 'cannot edit question' do
        question1
        old_title = question1.title
        old_body = question1.body
        patch :update, id: question1, question: { title: 'edited title', body: 'edited body' }, format: 'js'
        question.reload
        expect(question1.title).to eq old_title
        expect(question1.body).to eq old_body
      end

      it 'renders update view' do
        patch :update, id: question1, question: attributes_for(:question), format: 'js'
        expect(response).to render_template :update
      end
    end
  end

end
