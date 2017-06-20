require_relative '../feature_helper'

feature 'Author can select best answer', %q{
  In order to select the best answer for my question
  As an Author
  I want to be able to mark the answer as the best
} do

  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question) { create(:question_author, author: author1) }
  given!(:answers) { create_list(:answer, 3, question: question, author: author2) }

  before do
    answers.first.best_answer = true
  end

  context 'Question author' do
    before do
      sign_in(author1)
      visit question_path(question)
    end

    scenario 'can select best answer', js: true do
      within "#answer-#{answers.second.id}" do
        click_on 'Select as the best answer'

        expect(page).to_not have_content 'Select as the best answer'
        expect(page).to have_content 'Best answer'
      end
    end

    scenario 'Question can have only one best answer', js: true do
      sleep 2
      within "#answer-#{answers.last.id}" do
        click_on 'Select as the best answer'
      end

      expect(page).to have_content 'Best answer', count: 1
    end

    scenario 'can select another best answer', js: true do
      sleep 2
      within "#answer-#{answers.last.id}" do
        click_on 'Select as the best answer'

        expect(page).to_not have_content 'Select as the best answer'
        expect(page).to have_content 'Best answer'
      end
      sleep 1
      within "#answer-#{answers.second.id}" do
        click_on 'Select as the best answer'

        expect(page).to_not have_content 'Select as the best answer'
        expect(page).to have_content 'Best answer'
      end

      expect(page).to have_content 'Best answer', count: 1
    end

    scenario 'best question is the first in list', js: true do
      sleep 1
      within "#answer-#{answers.last.id}" do
        click_on 'Select as the best answer'
      end
      expect(page).to have_css(".answer:first-child .text", text: answers.last.body)
    end
  end

  context 'Unauthenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'cannot select best answer' do
      expect(page).to_not have_content 'Select as the best answer'
    end

    scenario 'can see best answer' do
      expect(page).to have_content 'Best answer'
    end
  end

  context 'Not question author' do
    before do
      sign_in(author2)
      visit question_path(question)
    end

    scenario 'cannot select best answer' do
      expect(page).to_not have_content 'Select as the best answer'
    end

    scenario 'can see best answer' do
      expect(page).to have_content 'Best answer'
    end
  end

end
