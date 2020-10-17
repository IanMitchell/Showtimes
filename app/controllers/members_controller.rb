class MembersController < ApplicationController
  include ErrorHandler

  before_action :authorize_group, only: [:create]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error 404, "That member is not part of this group!"
  end

  def show
    @group = Group.find_by_discord(params[:discord])
    @member = Member.find_by!(group: @group, discord: params[:user_id])
  end

  def create
    member = Member.find_or_create_by(group: @group, discord: params[:user_id])
    member.update(name: params[:user_name], admin: params[:admin])

    render json: {
      message: "Added #{params[:name]} to your group!"
    }, status: 200
  end
end
