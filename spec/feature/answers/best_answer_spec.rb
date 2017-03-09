require_relative '../feature_helper'

feature 'Author can select best answer', %q{
  In order to select the best answer for my question
  As an Author
  I want to be able to mark the answer as the best
} do

  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question) { create(:question_author, author: author1) }
  given!(:answers) { create_list(:answer, 3, question: question, author: author2) }

  scenario 'Question\'s author can select only one best answer' do
    sign_in(author1)

    visit question_path(question)

    within "#answer-#{answers[0].id}" do
      click_on 'Select as the best answer'

      expect(page).to_not have_content 'Select as the best answer'
      expect(page).to have_content 'Best answer'
    end
  end
end