require 'rails_helper'

feature 'Author can delete it\'s questions', %q{
  In order to delete questions
  As a user
  I need to be a question's author
} do

  given!(:user) { create(:user) }
  given!(:question_author) { create(:question_author, user: user) }
  given!(:question) { create(:questions) }
  given!(:answers) { create_list(:answer, 3, question: questions) }
  given!(:answers) { create_list(:answer, 3, question: question_author) }

  
  scenario 'Author can delete it\'s questions' do
    sign_in(user)

    visit question_path(question_author)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    visit questions_path

    expect(page).to_not have_content question_author.title

  end

  scenario 'Non-question-author cannot delete others questions' do

  end
end