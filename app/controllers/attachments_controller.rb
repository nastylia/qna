class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
    @item = @attachment.attachable
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end

end
