require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "Votable"
  it_behaves_like "Commentable"
  it_behaves_like "Authorable"
  it_behaves_like "Attachable"

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
end
