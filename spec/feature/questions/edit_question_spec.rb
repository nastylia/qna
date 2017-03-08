require_relative '../feature_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As a question author
  I want to be able to edit my question
} do
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:question) { create(:question_author, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Not author cannot see edit link for other questions' do
    sign_in(user1)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do

    before  do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Only author sees edit link' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'Author tries to edit his question', js: true do
      click_on 'Edit question'
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Author tries to edit his question with nothing', js: true do
      click_on 'Edit question'
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end

  end
  
end