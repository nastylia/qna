class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  authorize_resource :user

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def all_but_me
    respond_with all_users_except_current_resource_owner
  end

end
