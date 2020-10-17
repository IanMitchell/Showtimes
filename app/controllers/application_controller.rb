class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def authorize_group
    @group = Group.find_by_discord_and_authorize(params[:discord], params[:token])
  end
end
