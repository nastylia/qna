require 'rails_helper'

feature 'List questions', %q{
  In order to search the question
  As a user
  I want to view the list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:questions, 3) }

  scenario 'Authenticated user browse questions' do

    sign_in(user)
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'Non-authenticated user browse questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
    
  end
end