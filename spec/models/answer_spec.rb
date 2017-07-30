require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "Votable"
  it_behaves_like "Commentable"
  it_behaves_like "Authorable"
  it_behaves_like "Attachable"

  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_db_index :question_id }

  let(:author) { create(:user) }
  let(:question) { create(:question_author, author: author) }
  let(:answers) { create_list(:answer, 5, question: question, author: author) }

  describe 'ordered scope' do
    context 'best answer is selected' do
      it 'checks that the best answer is the first in list' do
        answer_body = answers.last.body
        answers.last.best_answer = true
        answers.last.save

        expect(Answer.ordered.first.body).to eq answer_body
      end
    end
  end

  describe 'select_new_best_answer' do
    context 'best answer is selected' do
      it 'checks that the best answer is saved in db' do
        answers.last.best_answer = true
        answers.last.select_new_best_answer(question.answers)
        question.reload

        expect(question.answers.find(answers.last).best_answer).to eq true
      end

      it 'checks that only one best answer is in db at the moment' do
        answers.last.best_answer = true
        answers.last.select_new_best_answer(question.answers)

        answers.first.best_answer = true
        answers.first.select_new_best_answer(question.answers)
        question.reload

        count = 0
        question.answers.each do |a|
          count = count + 1 if a.best_answer == true
        end

        expect(count).to eq 1
        expect(question.answers.find(answers.first).best_answer).to eq true
      end
    end
  end
end
