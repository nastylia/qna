require 'rails_helper'

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
  given!(:answers_author1) { create_list(:answer, 3, question: question_author2, author: author1) }

  scenario 'Author can delete it\'s answers' do
    sign_in(author1)
  end
  
end