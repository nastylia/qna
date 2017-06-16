require 'rails_helper'

shared_examples 'voted' do

  describe 'patch#up' do
    context 'user is signed in' do
      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      sign_in_user

      it 'responds with success' do
        patch :up, id: answer, format: 'json'
        expect(response).to have_http_status(:success)
      end

      it 'changes vote value to be 1' do
        expect { patch :up, id: answer, format: 'json'}.to change(Vote, :count).by(1)
        vote = Vote.where(user_id: @user, votable_type: 'Answer', votable_id: answer).first
        expect(vote.value).to eq 1
      end
    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }

      it 'respondss with unauthorized' do
        patch :up, id: answer, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t save new vote' do
        expect { patch :up, id: answer, format: 'json'}.to_not change(Vote, :count)
      end
    end
  end
end
