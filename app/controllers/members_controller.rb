class MembersController < ApplicationController
  include ErrorHandler

  before_action :authorize_group, only: [:create]

  def show
    @group = Group.find_by_discord(params[:discord])
    @member = Member.find_by(group: @group, discord: params[:user_id])

    if @member.nil?
      return render json: { message: "That member is not part of this group!" }, status: 404
    end
  end

  def create
    member = Member.find_or_create_by(group: @group, discord: params[:user_id])
    member.update(name: params[:user_name], admin: params[:admin])

    render json: {
      message: "Added #{params[:name]} to your group!"
    }, status: 200
  end
end
