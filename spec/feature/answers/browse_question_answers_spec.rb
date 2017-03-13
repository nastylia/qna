require_relative '../feature_helper'

feature 'Browse question\'s answers', %q{
  In order to get help from comminuty
  As a user
  I want to be able to browse question's answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_author, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario 'Authenticated user can view question\'s answers' do
    sign_in(user)

    visit question_path(question)

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end

  scenario 'Non-authenticated user can view question\'s answers' do
    visit question_path(question)

    answers.each do |a|
      expect(page).to have_content a.body
    end

  end
  
end