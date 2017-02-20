require 'rails_helper'

feature 'User sign out', %q{
  In order to not stayed signed in
  As a User
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign out' do
    visit new_user_session_path

    expect(page).not_to have_content('Sign out')
  end
end