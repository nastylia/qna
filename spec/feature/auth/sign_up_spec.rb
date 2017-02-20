require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As a User
  I want to be able to sign up
} do

  scenario 'Non-registered user tries to sign up' do

    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'nastya@mail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
# TODO: check that we go back to the page from where we want to sign in, sign up
  end
  
end