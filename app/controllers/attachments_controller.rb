class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  # def is_author?
  #   respond_with (@item) do |format|
  #     flash[:notice] = 'You are not authorized to perform this action'
  #     format.js { head :forbidden }
  #   end unless current_user.author_of?(@item)
  # end

  def load_attachment
    @attachment = Attachment.find(params[:id])
    @item = @attachment.attachable
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end

end
