require_relative '../feature_helper'

feature 'Vote for question', %q{
  In order to illustrate my attitude to the question
  As an authenticated user
  I want to be able to vote for or against the question
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question_author, author: author) }

  context 'Authenticated user' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'User can vote for the question he likes', js: true do
      within ".question" do
        click_on "Up"
        expect(page).to have_content 'Votes: 1'
      end
    end

    scenario 'User can down vote the question he dislikes', js: true do
      within ".question" do
        click_on "Down"
        expect(page).to have_content 'Votes: -1'
      end
    end

  end

  context 'Non-authenticated user' do

    scenario 'User cannot vote for the question he likes' do
      visit question_path(question)
      within ".question" do
        click_on "Up"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'User cannot down vote the question he dislikes' do
      visit question_path(question)
      within ".question" do
        click_on "Down"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
