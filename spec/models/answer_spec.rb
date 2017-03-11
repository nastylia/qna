require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_db_index :question_id }
  it { should validate_presence_of :author }
  it { should belong_to(:author).class_name('User') }

  describe 'ordered scope' do
    let(:author) { create(:user) }
    let(:question) { create(:question_author, author: author) }
    let(:answers) { create_list(:answer, 5, question: question, author: author) }

    context 'best answer is selected' do
      it 'checks that the best answer is the first in list' do
        answer_body = answers.last.body
        answers.last.best_answer = true
        answers.last.save

        expect(Answer.ordered.first.body).to eq answer_body
      end
    end
  end
end
