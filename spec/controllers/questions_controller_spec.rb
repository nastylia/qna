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
end
