class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  authorize_resource class: User

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with all_but_me
  end

  protected

  def all_but_me
    @all_but_me ||= User.where.not(id: current_resource_owner)
  end

end
