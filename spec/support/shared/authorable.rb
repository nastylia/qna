shared_examples_for 'Authorable' do
  it { should validate_presence_of :author }
  it { should belong_to(:author).class_name('User') }
end
