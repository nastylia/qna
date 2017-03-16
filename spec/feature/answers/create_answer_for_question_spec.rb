require_relative '../feature_helper'
feature 'Create answer for a question', %q{
  In order to answer the question
  As an authenticated user
  I want to be able to create new answer on the question's page
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_author, author: user) }

  scenario 'Authenticated user answers the question', js: true do
    sign_in(user)
    sleep(1)

    visit question_path(question)
    fill_in 'Your answer', with: 'Awesome answer'
    click_on 'Post Your Answer'

    within ".answers" do
      expect(page).to have_content 'Awesome answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    sign_in(user)
    sleep(1)

    visit question_path(question)
    click_on 'Post Your Answer'

    expect(page).to have_content 'Cannot save Answer:'
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user answers the question' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Awesome answer'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
  
end