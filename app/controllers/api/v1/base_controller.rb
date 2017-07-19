class Api::V1::BaseController < ApplicationController

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def all_users_except_current_resource_owner
    @all_users_except_current_resource_owner ||= User.where.not(id: current_resource_owner)
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
