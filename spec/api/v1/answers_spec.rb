require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      let!(:question) { create(:question) }

      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access tokenis not valid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.last }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
         expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(id body best_answer question_id created_at updated_at author_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end

    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is not valid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.last }
      let!(:comments) { create_list(:my_comment, 3, commentable: answer) }
      let(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }
      let(:attachment) { attachments.last }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
         expect(response).to be_success
      end

      it 'returns one question' do
        expect(response.body).to have_json_size(9).at_path("answer")
      end

      %w(id body best_answer question_id created_at updated_at author_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'is included in question object' do
          expect(response.body).to have_json_size(3).at_path("answer/comments")
        end

        %w(id comment user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'is included in question object' do
          expect(response.body).to have_json_size(3).at_path("answer/attachments")
        end

        it 'returns correct url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end

        %w(id file created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end

    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      it 'returns 401 status if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access tokenis not valid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let(:answer) { attributes_for(:answer) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer, question_id: question, format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it "question id is correct" do
        expect(response.body).to be_json_eql(question.id.to_json).at_path("answer/question_id")
      end

      it "best_answer is false" do
        expect(response.body).to be_json_eql(false.to_json).at_path("answer/best_answer")
      end

      %w(body).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer[attr.to_sym].to_json).at_path("answer/#{attr}")
        end
      end
    end

  end

end
