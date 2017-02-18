require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to askquestion
} do

  given(:user) {create(:user)}
  scenario 'Authenticated user creates a question' do
    sign_in(user)


    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'My awesome question'
    fill_in 'Body', with: 'test'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    # TODO check question content, page....
    # expect(current_path).to eq questions_path
  end

  scenario 'Non-athenticated user creates a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
