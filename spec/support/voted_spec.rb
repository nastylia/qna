require 'rails_helper'

shared_examples 'voted' do
  let(:controller) { described_class }
  let(:votable_type) { controller.to_s.match(/(.*)Controller/)[1].singularize }

  describe 'patch#up' do
    context 'user is signed in' do

      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      sign_in_user

      it 'responds with success' do
        # binding.pry
        patch :up, id: votable, format: 'json'
        expect(response).to have_http_status(:success)
      end

      it 'changes vote value to be 1' do
        expect { patch :up, id: votable, format: 'json'}.to change(Vote, :count).by(1)
        vote = Vote.where(user_id: @user, votable_type: votable_type, votable_id: votable).first
        expect(vote.value).to eq 1
      end
    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}

      it 'respondss with unauthorized' do
        patch :up, id: votable, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t save new vote' do
        expect { patch :up, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end
  end

  describe 'patch#down' do
    context 'user is signed in' do
      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      sign_in_user

      it 'responds with success' do
        patch :down, id: votable, format: 'json'
        expect(response).to have_http_status(:success)
      end

      it 'changes vote value to be -1' do
        expect { patch :down, id: votable, format: 'json'}.to change(Vote, :count).by(1)
        vote = Vote.where(user_id: @user, votable_type: votable_type, votable_id: votable).first
        expect(vote.value).to eq -1
      end
    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}

      it 'respondss with unauthorized' do
        patch :down, id: votable, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t save new vote' do
        expect { patch :down, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end
  end
end
