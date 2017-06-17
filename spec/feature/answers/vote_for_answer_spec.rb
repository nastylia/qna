require_relative '../feature_helper'

feature 'Vote for answer', %q{
  In order to illustrate my attitude to the answer
  As an authenticated user
  I want to be able to vote for or against the answer
} do

  given!(:author) { create(:user) }
  given!(:user) {create(:user)}
  given!(:question) { create(:question_author, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  context 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can vote for the answer he likes', js: true do
      within "#answer-#{answer.id}" do
        click_on "Up"
        expect(page).to have_content 'Votes: 1'
      end
    end

    scenario 'User can down vote the answer he dislikes', js: true do
      within "#answer-#{answer.id}" do
        click_on "Down"
        expect(page).to have_content 'Votes: -1'
      end
    end

  end

  context 'Authenticated user is answer\'s author' do

    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Author cannot vote for his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on "Up"
        expect(page).to have_content 'Votes: 0'
      end
      expect(page).to have_content 'You are the author of the Answer. You cannot vote.'
    end

    scenario 'Author cannot down vote his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on "Down"
        expect(page).to have_content 'Votes: 0'
      end
      expect(page).to have_content 'You are the author of the Answer. You cannot vote.'
    end

  end

  context 'Non-authenticated user' do

    scenario 'User cannot vote for the answer he likes' do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on "Up"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'User cannot down vote the answer he dislikes' do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on "Down"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
