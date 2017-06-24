require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'create #create' do
    context 'user is signed in' do
      let(:user) { create(:user) }
      let(:question) { create(:question_author, author: user) }
      sign_in_user

      it 'creates new comment in db' do
        expect { post :create, params: { commentable: 'question',
                                         comment: {comment: "awesome comment"},
                                         question_id: question.id,
                                         format: 'json' }}.to  change(question.comments, :count).by(1)
      end

      it 'responds with success' do
        post :create, params: { commentable: 'question',
                                comment: {comment: "awesome comment"},
                                question_id: question.id,
                                format: 'json' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'user is not authenticated' do
      let(:user) { create(:user) }
      let(:question) { create(:question_author, author: user) }

      it 'does not create comment in db' do
        expect { post :create, params: { commentable: 'question',
                                         comment: {comment: "awesome comment"},
                                         question_id: question.id,
                                         format: 'json' }}.to_not change(question.comments, :count)
      end

      it 'responds with unauthorized' do
        post :create, params: { commentable: 'question',
                                comment: {comment: "awesome comment"},
                                question_id: question.id,
                                format: 'json' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
