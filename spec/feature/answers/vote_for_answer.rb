require_relative '../feature_helper'

feature 'Vote for answer', %q{
  In order to illustrate my attitude to the answer
  As an authenticated user
  I want to be able to vote for or against the answer
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question_author, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }  

  scenario 'Authenticated user can vote for the answer he likes', js: true do
    sign_in(author)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on "Vote"

      expect(page).to have_content 'Votes: 1'
    end
  end

  scenario 'Non-uthenticated user cannot vote for the answer he likes' do

  end

end