require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to askquestion
} do

  given(:user) { create(:user) }
  scenario 'Authenticated user creates a question' do
    sign_in(user)


    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'My awesome question'
    fill_in 'Body', with: 'test'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    expect(page).to have_content 'My awesome question'
    expect(page).to have_content 'test'
  end

  scenario 'Authenticated user creates invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Cannot save Question:'
    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'

  end

  scenario 'Non-athenticated user creates a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
