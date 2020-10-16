class MembersController < ApplicationController
  before_action :require_authorization, only: [:create]

  def show
    @group = Group.find_by_discord(params[:channel])
    @member = Member.find_by(group: @group, discord: params[:discord])

    if @member.nil?
      return render json: { message: "That member is not part of this group!" }, status: 404
    end
  end

  def create
    @group = Group.find_by_discord(params[:channel])

    if Member.exists?(group: @group, discord: params[:discord])
      return render json: { message: "They're already a member of your group!" }, status: 400
    end

    @member = Member.create(group: @group, discord: params[:discord], name: params[:name])
    render json: { message: "Added #{params[:name]} to your group!" }, status: 200
  end
end
