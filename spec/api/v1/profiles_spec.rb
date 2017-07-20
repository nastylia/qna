require 'rails_helper'

describe 'Profile API' do

  describe 'GET /' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access tokenis not valid' do
        get '/api/v1/profiles', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 3) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not contain current_resource_owner' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr} in each returned user" do
          returned_users = JSON.parse(response.body)
          [returned_users, users].transpose.each do |r_u, u|
            expect(r_u[attr].to_json).to eq u[attr].to_json
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end
  end

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access token is not valid' do
        get '/api/v1/profiles/me', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create (:user) }
      let (:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end
end
