shared_examples_for "API Commentable" do
  context 'comments' do
    it "is included in object" do
      expect(response.body).to have_json_size(3).at_path("#{object_name}/comments")
    end

    %w(id comment user_id).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{object_name}/comments/0/#{attr}")
      end
    end
  end
end
