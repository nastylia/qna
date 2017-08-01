shared_examples_for "Votable" do
  let(:model) { described_class }

  let(:author) { create(:user) }
  let(:user) { create_list(:user, 6) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author) }
  let(:votable) { model.to_s == 'Answer' ? answer : question}
  let!(:vote0) { create(:vote, user: user[0], votable: votable, value: 1) }
  let!(:vote1) { create(:vote, user: user[1], votable: votable, value: -1) }
  let!(:vote2) { create(:vote, user: user[2], votable: votable, value: 1) }
  let!(:vote3) { create(:vote, user: user[3], votable: votable, value: 1) }
  let!(:vote4) { create(:vote, user: user[4], votable: votable, value: 1) }

  describe 'sum_votes' do
    it 'summarizes votes' do
      expect(votable.sum_votes).to eq 3
    end
  end

  describe 'vote' do
    it 'returns new vote if current user is not an author' do
      vote = votable.vote(value: 1, current_user: user[5])

      expect(vote.votable_type).to eq model.to_s
      expect(vote.votable_id).to eq votable.id
      expect(vote.user).to eq user[5]
      expect(votable.votes.sum(:value)).to eq 4
    end

    it 'does not return new vote if current user has voted already' do
      expect(votable.vote(value: 1, current_user: user[0])).to eq nil
    end
  end

  describe 'unvote' do
    it 'deletes a vote if current user is not an author' do
      vote = votable.unvote(current_user: user[0])

      expect(vote.votable_type).to eq model.to_s
      expect(vote.votable_id).to eq votable.id
      expect(vote.user).to eq user[0]
      expect(votable.votes.sum(:value)).to eq 2
    end

    it 'does not delete a vote if current user is an author' do
      expect(votable.unvote(current_user: author)).to eq nil
      expect(votable.votes.sum(:value)).to eq 3
    end

    it 'does not delete a vote if current user did not voted before' do
      expect(votable.unvote(current_user: user[5])).to eq nil
      expect(votable.votes.sum(:value)).to eq 3
    end
  end
end
