require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "Votable"
  it_behaves_like "Commentable"

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should validate_presence_of :author }
  it { should belong_to(:author).class_name('User') }

  it { should accept_nested_attributes_for :attachments }
end
