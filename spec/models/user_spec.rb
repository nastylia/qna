require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }

  describe 'author_of method' do
    let(:author) { create(:user) }
    let(:current_user) { create(:user) }
    let(:question) { create(:question_author, author: author) }
    let(:answer) { create(:answer, question: question, author: author) }
    context 'item\'s author and user are the same' do
      it 'compares question\'s author and user' do
        expect(author).to be_author_of(question)
      end

      it 'compares answer\'s author and user' do
        expect(author).to be_author_of(answer)
      end
    end

    context 'item\'s author and user are different' do
      it 'compares question\'s author and user' do
        expect(current_user).to_not be_author_of(question)
      end

      it 'compares answer\'s author and user' do
        expect(current_user).to_not be_author_of(answer)
      end
    end
  end
end