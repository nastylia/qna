require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  

  describe 'delete #destroy' do

    context 'signed in user is an author' do
      let(:question) { create(:question_author, author: @user) }
      let(:file) {create(:attachment, attachable: question)}
      sign_in_user

      it 'deletes attachment' do
        file
        expect { delete :destroy, id: file, question_id: question, format: 'js'}.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: file, question_id: question, format: 'js'
        expect(response).to render_template :destroy
      end
    end

    context 'signed in user is not an author' do
      let(:user) { create(:user) }
      let(:question) { create(:question_author, author: user) }
      let(:file) {create(:attachment, attachable: question)}
      sign_in_user

      it 'cannot delete attachment' do
        file
        expect { delete :destroy, id: file, question_id: question, format: 'js'}.to_not change(Attachment, :count)
      end
      it 'renders 403 status' do
        delete :destroy, id: file, question_id: question, format: 'js'
        expect(response).to have_http_status(403)
      end
    end
  end
end