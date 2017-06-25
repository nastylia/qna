require_relative '../feature_helper'

feature 'add comments', %q{
  In order to leave comments to answers
  As an authenticated user
  I want to be able to comment
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  context 'Authenticated user' do
    scenario 'can comment answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Awesome comment'
        click_on 'Publish'

        expect(page).to have_content 'Awesome comment'
      end
    end

    scenario 'Comment field is not visible', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Add comment'
        expect(page).to_not have_content 'Your comment'
        expect(page).to_not have_content 'Publish'
      end
    end

    scenario 'as soon as comment is added, form for new comment disappears', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Awesome comment'
        click_on 'Publish'

        expect(page).to_not have_content 'Your comment'
        expect(page).to_not have_content 'Publish'
        expect(page).to have_content 'Add comment'
      end
    end
  end

  context 'Not authenticated user' do
    scenario 'cannot comment question', js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Add comment'
        expect(page).to_not have_content 'Your comment'
        expect(page).to_not have_content 'Publish'
      end
    end
  end
end
