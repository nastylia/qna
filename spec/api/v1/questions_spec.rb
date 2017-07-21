require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access tokenis not valid' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
         expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'is included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}", id: question, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is not valid' do
        get "/api/v1/questions/#{question.id}", id: question, format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:comments) { create_list(:my_comment, 3, commentable: question) }
      let(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 3, attachable: question) }
      let(:attachment) { attachments.last }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
         expect(response).to be_success
      end

      it 'returns one question' do
        expect(response.body).to have_json_size(7).at_path("question")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'is included in question object' do
          expect(response.body).to have_json_size(3).at_path("question/comments")
        end

        %w(id comment user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'is included in question object' do
          expect(response.body).to have_json_size(3).at_path("question/attachments")
        end

        it 'returns correct url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end

        %w(id file created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end

    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        post '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access tokenis not valid' do
        post '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { attributes_for(:question) }

      before { post "/api/v1/questions", params: { question: question, format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(title body).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question[attr.to_sym].to_json).at_path("question/#{attr}")
        end
      end
    end
  end

end
