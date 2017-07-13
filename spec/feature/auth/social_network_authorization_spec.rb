require_relative '../feature_helper'

feature 'User authorization via social networks', %q{
  In order to be able to sign up, sign in via social networks
  As a User
  I want to be able to sign up, sign in viafacebook and twitter
} do

  background do
    clear_emails
  end

  scenario 'Non-registered user tries to sign up via twitter' do
    visit new_user_session_path
    expect(page).to have_content('Sign in with Twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Confirm your e-mail:'
    fill_in 'Your e-mail', with: 'test@email.com'
    click_on 'Confirm'

    open_email('test@email.com')
    expect(current_email).to have_content 'You can confirm your account email through the link below:'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(page).to have_link 'Sign out'
  end

  scenario 'Non-registered user tries to sign up via facebook' do
    facebook_with_email_mock
    visit new_user_session_path
    expect(page).to have_content('Sign in with Facebook')
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_link 'Sign out'
  end

  describe 'Non-authenticated user tries to sign in via twitter' do
    context 'user signed up before with twitter' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:twitter) { create(:social_network, user: user, provider: twitter_mock.provider, uid: twitter_mock.uid) }
      scenario 'sign_in with twitter' do
        visit new_user_session_path
        expect(page).to have_content('Sign in with Twitter')
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Successfully authenticated from Twitter account.'
        expect(page).to have_link 'Sign out'
      end
    end

    context 'user signed up before with facebook' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:twitter) { create(:social_network, user: user, provider: facebook_with_email_mock.provider, uid: facebook_with_email_mock.uid) }
      scenario 'sign_in with twitter' do
        twitter_mock
        visit new_user_session_path
        expect(page).to have_content('Sign in with Twitter')
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Confirm your e-mail:'
        fill_in 'Your e-mail', with: 'test@email.com'
        click_on 'Confirm'

        expect(page).to have_content 'Successfully authenticated from Twitter account.'
        expect(page).to have_link 'Sign out'
      end
    end

    context 'user signed up before on the site' do
      let!(:user) { create(:user, email: 'test@email.com') }
      scenario 'sign_in with twitter' do
        twitter_mock
        visit new_user_session_path
        expect(page).to have_content('Sign in with Twitter')
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Confirm your e-mail:'
        fill_in 'Your e-mail', with: 'test@email.com'
        click_on 'Confirm'

        expect(page).to have_content 'Successfully authenticated from Twitter account.'
        expect(page).to have_link 'Sign out'
      end
    end
  end

  describe 'Non-authenticated user tries to sign in via facebook' do
    context 'user signed up before with twitter' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:twitter) { create(:social_network, user: user, provider: twitter_mock.provider, uid: twitter_mock.uid) }
      scenario 'sign_in with facebook' do
        facebook_with_email_mock
        visit new_user_session_path
        expect(page).to have_content('Sign in with Facebook')
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(page).to have_link 'Sign out'
      end
    end

    context 'user signed up before with facebook' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:twitter) { create(:social_network, user: user, provider: facebook_with_email_mock.provider, uid: facebook_with_email_mock.uid) }
      scenario 'sign_in with facebook' do
        facebook_with_email_mock
        visit new_user_session_path
        expect(page).to have_content('Sign in with Facebook')
        click_on 'Sign in with Facebook'
        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(page).to have_link 'Sign out'
      end
    end

    context 'user signed up before on the site' do
      let!(:user) { create(:user, email: 'test@email.com') }
      scenario 'sign_in with facebook' do
        facebook_with_email_mock
        visit new_user_session_path
        expect(page).to have_content('Sign in with Facebook')
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(page).to have_link 'Sign out'
      end
    end
  end

end
