require_relative '../feature_helper'

feature 'Delete files from question', %q{
  In order to delete attached files from question
  As a question author
  I want to be able to delete files
} do
  
  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question_author1) { create(:question_author, author: author1) }
  given!(:file) {create(:attachment, attachable: question_author1)}

  scenario 'Author can delete attached file from his question' do
    sign_in(author1)
    visit question_path(question_author1)
    expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"

    click_on 'Delete file'
    expect(page).to_not have_link 'test1'


  end
  scenario 'Authenticated user, not author cannot delete attached file from a question'
  scenario 'Not authenticated user cannot delete attached file from a question'
  
end