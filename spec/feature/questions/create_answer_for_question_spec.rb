require 'rails_helper'

feature 'Create answer for a question', %q{
  In order to answer the question
  As an authenticated user
  I want to be able to create new answer on the question's page
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Awesome answer'
    click_on 'Post Your Answer'

    expect(page).to have_content 'Awesome answer'
    expect(current_path).to eq question_path(question)

  end

  scenario 'Non-authenticated user answers the question' do
    visit question_path(question)
    fill_in 'Body', with: 'Awesome answer'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
  
end