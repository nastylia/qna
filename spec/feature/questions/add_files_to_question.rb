require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question author
  I want to be able to attach files
} do
  
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when he asks question' do
    fill_in 'Title', with: 'My awesome question'
    fill_in 'Body', with: 'test'
    attach_file 'File', "#{Rails.root}/spec/test_files/test1"
    click_on 'Create'

    expect(page).to have_link 'test1', href: "/uploads/attachment/file/1/test1"

  end

  
end