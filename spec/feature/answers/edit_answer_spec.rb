require_relative '../feature_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I want to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:question) { create(:question_author, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Non-authenticated user tries to edir answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Not author cannot see edit link for other answers' do
    sign_in(user1)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do

    before  do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Only author sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Author tries to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Author tries to edit his answer with nothing', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end

  end

end