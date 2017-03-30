require_relative '../feature_helper'

feature 'Delete files from answer', %q{
  In order to delete attached files from answer
  As an answer author
  I want to be able to delete files
} do
  
  given!(:author1) { create(:user) }
  given!(:author2) { create(:user) }
  given!(:question_author1) { create(:question_author, author: author1) }
  given!(:answer_author1) { create(:answer, question: question_author1, author: author1) }
  given!(:file) {create(:attachment, attachable: answer_author1)}

  scenario 'Author can delete attached file from his answer', js: true do
    sign_in(author1)
    visit question_path(question_author1)
    within ".answers" do
      expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"

      click_on 'Delete file'
      expect(page).to_not have_link 'test1'
    end

  end

  scenario 'Authenticated user, not author cannot delete attached file from an answer' do
    sign_in(author2)
    visit question_path(question_author1)
    within ".answers" do
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Not authenticated user cannot delete attached file from an answer' do
    visit question_path(question_author1)
    within ".answers" do
      expect(page).to_not have_link 'Delete file'
    end
  end
  
end