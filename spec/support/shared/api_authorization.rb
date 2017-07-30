shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access tokenis not valid' do
      do_request(access_token: '12345')
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    before { do_request(access_token: access_token.token) }
    it 'returns 200 status code' do
       expect(response).to be_success
    end
  end
end
