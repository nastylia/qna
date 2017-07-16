require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    action = exception.action
    subject_object = exception.subject
    subject = subject_object.to_s

    respond_to do |format|
      format.js {
        flash[:notice] = exception.message
        render status: :forbidden
      }
      format.json { render json: { error: exception.message }, status: :forbidden }
      format.html {
        if subject_object.is_a?(Question) && action == :destroy
          redirect_to question_path(subject_object), notice: exception.message
        else
          redirect_to main_app.root_url, notice: exception.message
        end
      }
    end
    # redirect_to root_url, alert: exception.message
    #render...
  end



  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
