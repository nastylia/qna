class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if current_user.author_of?(@item)
      @attachment.destroy
    else
      head :forbidden
    end
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