require_relative '../feature_helper'

feature 'Author can delete it\'s answers', %q{
  In order to delete answers
  As a user
  I need to be an answer's author
} do
  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question_author1) { create(:question_author, author: author1) }
  given!(:question_author2) { create(:question_author, author: author2) }
  given!(:answers_author2) { create_list(:answer, 3, question: question_author1, author: author2) }
  given!(:answers_author1) { create(:answer, question: question_author2, author: author1) }

  scenario 'Author can delete it\'s answers', js: true do
    sign_in(author1)

    visit question_path(question_author2)

    expect(page).to have_content answers_author1.body
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question_author2)

    expect(page).to_not have_content answers_author1.body
  end

  scenario 'Non-answer-author cannot delete someone else answer' do
    sign_in(author1)
    visit question_path(question_author1)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Not authorized user cannot delete answer' do
    visit question_path(question_author1)

    expect(page).to_not have_content 'Delete answer'
  end
  
end