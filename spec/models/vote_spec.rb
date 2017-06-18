require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :user }
  it { should belong_to :votable }

  let!(:user) { create_list(:user, 5) }
  let!(:question) { create(:question, author: user[0]) }
  let!(:answer) { create(:answer, question: question, author: user[0]) }
  let!(:vote1) { create(:vote, user: user[1], votable: answer, value: 1) }
  let!(:vote2) { create(:vote, user: user[2], value: 1, votable: answer) }
  let!(:vote3) { create(:vote, user: user[3], value: -1, votable: answer) }

  describe 'vote' do

    it 'should return forbidden and unvote first' do
      res = Vote.vote(votable: answer, value: 1, current_user: user[3])
      expect(res[:status]).to eq :forbidden
      expect(res[:result][:error]).to eq "Unvote first"
    end

    it 'should return forbidden and message' do
      res = Vote.vote(votable: answer, value: 1, current_user: user[0])
      expect(res[:status]).to eq :forbidden
      expect(res[:result][:error]).to eq "You are the author of the #{answer.class.name}. You cannot vote."
    end


    it 'should return success' do
      res = Vote.vote(votable: answer, value: 1, current_user: user[4])
      expect(res[:result][:result_votes]).to eq 2
    end
  end

  describe 'unvote' do

    it 'should return success' do
      res = Vote.unvote(votable: answer, current_user: user[1])
      expect(res[:result][:result_votes]).to eq 0
    end

  end

end
