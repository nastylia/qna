require_relative '../feature_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As a User
  I want to be able to sign up
} do

  background do
    clear_emails
  end

  scenario 'Non-registered user tries to sign up' do

    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    open_email('test@email.com')
    expect(current_email).to have_content 'You can confirm your account email through the link below:'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
# TODO: check that we go back to the page from where we want to sign in, sign up
  end

end
