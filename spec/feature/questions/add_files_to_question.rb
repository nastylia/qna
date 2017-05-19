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

  scenario 'User adds several files when he asks question', js: true do
    fill_in 'Title', with: 'My awesome question'
    fill_in 'Body', with: 'test'

    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/test_files/test1")
    inputs[1].set("#{Rails.root}/spec/test_files/test2")
    click_on 'Create'

    expect(page).to have_link 'test2', href: "/uploads/attachment/file/3/test2"
    expect(page).to have_link 'test1', href: "/uploads/attachment/file/2/test1"

  end

  
end