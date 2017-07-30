shared_examples_for "API Attachable" do
  context 'attachments' do
    it 'is included in object' do
      expect(response.body).to have_json_size(3).at_path("#{object_name}/attachments")
    end

    it 'returns correct url' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{object_name}/attachments/0/url")
    end

    %w(id file created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("#{object_name}/attachments/0/#{attr}")
      end
    end
  end
end
