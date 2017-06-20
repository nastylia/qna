require 'rails_helper'

shared_examples 'voted' do
  let(:controller) { described_class }
  let(:votable_type) { controller.to_s.match(/(.*)Controller/)[1].singularize }

  describe 'patch#up' do
    context 'user is signed in' do

      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      sign_in_user

      it 'responds with success' do
        patch :up, id: votable, format: 'json'
        expect(response).to have_http_status(:success)
      end

      it 'changes vote value to be 1' do
        expect { patch :up, id: votable, format: 'json'}.to change(Vote, :count).by(1)
        vote = Vote.where(user_id: @user, votable_type: votable_type, votable_id: votable).first
        expect(vote.value).to eq 1
      end

      it 'responds with forbidden if vote twice' do
        patch :up, id: votable, format: 'json'
        expect { patch :up, id: votable, format: 'json'}.to_not change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'user is an author' do
      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      sign_in_user

      it 'responds with forbidden' do
        patch :up, id: votable, format: 'json'
        expect(response).to have_http_status(:forbidden)
      end

      it 'doesn\'t save new vote' do
        expect { patch :up, id: votable, format: 'json'}.to_not change(Vote, :count)
      end

    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}

      it 'responds with unauthorized' do
        patch :up, id: votable, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t save new vote' do
        expect { patch :up, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end
  end

  describe 'patch#unvote' do

    context 'user is signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}

      sign_in_user

      it 'decreases Vote number by one' do
        patch :up, id: votable, format: 'json'
        expect { patch :unvote, id: votable, format: 'json'}.to change(Vote, :count).by(-1)
      end

      it 'responds with success' do
        patch :up, id: votable, format: 'json'
        patch :unvote, id: votable, format: 'json'
        expect(response).to have_http_status(:success)
      end
    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      let(:vote) { create(:vote, user: user, value: 1, votable: votable) }

      it 'responds with unauthorized' do
        patch :unvote, id: votable, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t change Vote number' do
        expect { patch :unvote, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end

    context 'user is an author' do
      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      let(:vote) { create(:vote, user: user, value: 1, votable: votable) }

      sign_in_user

      it 'responds with forbidden' do
        patch :unvote, id: votable, format: 'json'
        expect(response).to have_http_status(:forbidden)
      end

      it 'doesn\'t change Vote number' do
        expect { patch :unvote, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end

  end

  describe 'patch#down' do
    context 'user is signed in' do
      let (:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
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

    context 'user is an author' do
      let(:question) { create(:question, author: @user) }
      let(:answer) { create(:answer, question: question, author: @user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}
      sign_in_user

      it 'responds with forbidden' do
        patch :down, id: votable, format: 'json'
        expect(response).to have_http_status(:forbidden)
      end

      it 'doesn\'t save new vote' do
        expect { patch :down, id: votable, format: 'json'}.to_not change(Vote, :count)
      end

    end

    context 'user is not signed in' do
      let(:user) {create(:user)}
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:votable) { votable_type == 'Answer' ? answer : question}

      it 'responds with unauthorized' do
        patch :down, id: votable, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'doesn\'t save new vote' do
        expect { patch :down, id: votable, format: 'json'}.to_not change(Vote, :count)
      end
    end
  end
end
