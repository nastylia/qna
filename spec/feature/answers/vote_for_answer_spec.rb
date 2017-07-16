require_relative '../feature_helper'

feature 'Vote for answer', %q{
  In order to illustrate my attitude to the answer
  As an authenticated user
  I want to be able to vote for or against the answer
} do

  given!(:author) { create(:user) }
  given!(:user) {create(:user)}
  let!(:users) { create_list(:user, 4) }
  given!(:question) { create(:question_author, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  let!(:vote1) { create(:vote, user: users[0], value: 1, votable: answer) }
  let!(:vote2) { create(:vote, user: users[1], value: 1, votable: answer) }
  let!(:vote3) { create(:vote, user: users[2], value: -1, votable: answer) }
  let!(:vote4) { create(:vote, user: users[3], value: 1, votable: answer) }

  context 'Authenticated user' do

    context 'Sign_in user' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can vote for the answer he likes', js: true do
        within "#answer-#{answer.id}" do
          click_on "Up"
          expect(page).to have_content 'Votes: 3'
        end
      end

      scenario 'User can down vote the answer he dislikes', js: true do
        within "#answer-#{answer.id}" do
          click_on "Down"
          expect(page).to have_content 'Votes: 1'
        end
      end

      scenario 'User cannot vote 2 times at a time', js: true  do
        within "#answer-#{answer.id}" do
          click_on "Up"
          sleep 1
          click_on "Up"
          expect(page).to have_content 'Votes: 3'
        end
        expect(page).to have_content 'Unvote first'
      end

      scenario 'User cannot down vote 2 times at a time', js: true  do
        within "#answer-#{answer.id}" do
          click_on "Down"
          sleep 1
          click_on "Down"
          expect(page).to have_content 'Votes: 1'
        end
        expect(page).to have_content 'Unvote first'
      end

      scenario 'User can vote then unvote then downvote', js: true  do
        within "#answer-#{answer.id}" do
          sleep 1
          click_on "Up"
          sleep 1
          click_on "Unvote"
          sleep 1
          click_on "Down"
          sleep 1
          expect(page).to have_content 'Votes: 1'
        end
      end
    end

    scenario 'User can unvote', js: true  do
      sign_in(users[0])
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on "Unvote"
        expect(page).to have_content 'Votes: 1'
      end
    end
  end

  context 'Authenticated user is answer\'s author' do

    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Author cannot unvote', js: true do
      within "#answer-#{answer.id}" do
        click_on "Unvote"
        expect(page).to have_content 'Votes: 2'
      end
    end

    scenario 'Author cannot vote for his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on "Up"
        expect(page).to have_content 'Votes: 2'
      end
      expect(page).to have_content 'You are the author of the answer. You cannot vote.'
    end

    scenario 'Author cannot down vote his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on "Down"
        expect(page).to have_content 'Votes: 2'
      end
      expect(page).to have_content 'You are the author of the answer. You cannot down vote.'
    end

  end

  context 'Non-authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'Votes are correctly displayed when the page is loaded' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Votes: 2'
      end
    end

    scenario 'User cannot vote for the answer he likes' do
      within "#answer-#{answer.id}" do
        click_on "Up"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'User cannot down vote the answer he dislikes' do
      within "#answer-#{answer.id}" do
        click_on "Down"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'User cannot unvote', js: true do
      within "#answer-#{answer.id}" do
        click_on "Unvote"
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
