require 'rails_helper'

feature 'Create question', %q{
  In order to ask question
  As a user
  I want to be able to create question
} do
  scenario 'A user tries to create a question' do
    visit questions_path
    click_on 'Ask question'

    # expect(page).to have_content 'Enter you question:'
    # expect(current_path).to eq new_question_path

    fill_in 'Title', with: 'My awesome question'
    fill_in 'Body', with: 'test'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    # expect(current_path).to eq questions_path
  end
end
