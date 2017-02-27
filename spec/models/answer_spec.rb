require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_db_index :question_id }
  it { should validate_presence_of :author }
  it { should belong_to(:author).class_name('User') }
end
