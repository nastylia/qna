require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.last }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(id body best_answer question_id created_at updated_at author_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end

    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    it_behaves_like "API Authenticable"

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

      let!(:object_name) { "answer" }
      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"

      it 'returns one answer' do
        expect(response.body).to have_json_size(9).at_path("answer")
      end

      %w(id body best_answer question_id created_at updated_at author_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }
    let(:answer) { attributes_for(:answer) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer, question_id: question, format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
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

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json, answer: answer, question_id: question }.merge(options)
    end

  end


end
