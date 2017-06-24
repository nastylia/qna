require_relative '../feature_helper'
feature 'Create answer for a question', %q{
  In order to answer the question
  As an authenticated user
  I want to be able to create new answer on the question's page
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question_author, author: user) }

  context 'Multiple sessions' do
    context 'user on another page is questions author' do
      scenario "answer appears on another user's page", js: true do
        Capybara.using_session('user1') do
          sign_in(user1)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('user1') do
          fill_in 'Your answer', with: 'Awesome answer'
          attach_file 'File', "#{Rails.root}/spec/test_files/test1"
          click_on 'Post Your Answer'

          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
          end
        end

        Capybara.using_session('user') do
          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
            expect(page).to have_content 'Votes: 0'
            expect(page).to have_content 'Up'
            expect(page).to have_content 'Unvote'
            expect(page).to have_content 'Down'
            expect(page).to have_link 'Select as the best answer', visible: false
          end
        end
      end
    end

    context 'user on another page is not authorized' do
      scenario "answer appears on another user's page", js: true do
        Capybara.using_session('user1') do
          sign_in(user1)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user1') do
          fill_in 'Your answer', with: 'Awesome answer'
          attach_file 'File', "#{Rails.root}/spec/test_files/test1"
          click_on 'Post Your Answer'

          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
          end
        end

        Capybara.using_session('guest') do
          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
            expect(page).to have_content 'Votes: 0'
            expect(page).to have_content 'Up'
            expect(page).to have_content 'Unvote'
            expect(page).to have_content 'Down'
            expect(page).to_not have_link 'Select as the best answer'
          end
        end
      end
    end

    context 'user on another page is authorized but not an author' do
      scenario "answer appears on another user's page", js: true do
        Capybara.using_session('user1') do
          sign_in(user1)
          visit question_path(question)
        end

        Capybara.using_session('user2') do
          sign_in(user2)
          visit question_path(question)
        end

        Capybara.using_session('user1') do
          fill_in 'Your answer', with: 'Awesome answer'
          attach_file 'File', "#{Rails.root}/spec/test_files/test1"
          click_on 'Post Your Answer'

          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
          end
        end

        Capybara.using_session('user2') do
          within ".answers" do
            expect(page).to have_content 'Awesome answer'
            expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
            expect(page).to have_content 'Votes: 0'
            expect(page).to have_content 'Up'
            expect(page).to have_content 'Unvote'
            expect(page).to have_content 'Down'
            expect(page).to_not have_link 'Select as the best answer'
          end
        end
      end
    end
  end

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
