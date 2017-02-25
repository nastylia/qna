require 'rails_helper'

feature 'Author can delete it\'s questions', %q{
  In order to delete questions
  As a user
  I need to be a question's author
} do

  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question_author1) { create(:question_author, author: author1) }
  given!(:question_author2) { create(:question_author, author: author2) }
  given!(:answers) { create_list(:answer, 3, question: question_author1) }
  given!(:answers) { create_list(:answer, 3, question: question_author2) }

  
  scenario 'Author can delete it\'s questions' do
    sign_in(author1)

    visit question_path(question_author1)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    visit questions_path

    expect(page).to_not have_content question_author1.title

  end

  scenario 'Non-question-author cannot delete others questions' do
    sign_in(author1)

    visit question_path(question_author2)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Not authorized user cannot delete question' do
    visit question_path(question_author2)
    expect(page).to_not have_content 'Delete question'
  end
end