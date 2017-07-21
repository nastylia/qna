require_relative '../feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_author, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when he answers', js: true do
    fill_in 'Your answer', with: 'test body answer'
    attach_file 'File', "#{Rails.root}/spec/test_files/test1"
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'test1', href: "/uploads/attachment/file/#{question.answers.first.attachments.first.id}/test1"
    end
  end

  scenario 'User adds several files when he answers', js: true do
    fill_in 'Your answer', with: 'test body answer'

    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/test_files/test1")
    inputs[1].set("#{Rails.root}/spec/test_files/test2")
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'test2', href: "/uploads/attachment/file/2/test2"
      expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"
    end

  end



end
