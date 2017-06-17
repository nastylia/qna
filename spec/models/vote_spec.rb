require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :user }
  it { should belong_to :votable }

  describe 'vote_reult scope' do
    let!(:user) { create_list(:user, 5) }
    let!(:question) { create(:question, author: user[0]) }
    let!(:vote1) { create(:vote, user: user[1], votable: question, value: 1) }
    let!(:vote2) { create(:vote, user: user[2], value: 1, votable: question) }
    let!(:vote3) { create(:vote, user: user[3], value: -1, votable: question) }
    let!(:vote4) { create(:vote, user: user[4], value: 1, votable: question) }

    it 'should sum up all votes and return result' do
      expect(Vote.vote_result('Question', question.id)).to eq 2
    end
  end
end
