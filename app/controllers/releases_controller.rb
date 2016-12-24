class ReleasesController < ApplicationController
  before_action :require_authorization, only: [:update]

  def show
    # @release = Release.find(params[:id])
    redirect_to group_path(Group.first)
  end

  def update
    @group = Channel.find_by(name: params[:channel] || params[:irc],
                             platform: Channel.from_platform(params[:platform]),
                             staff: true)&.group
    return render json: { message: 'Unknown channel' }, status: 400 if @group.nil?

    @show = Show.find_by_name_or_alias(params[:name])
    return render json: { message: 'Unknown show.' }, status: 400 if @show.nil?

    @fansub = @show.fansubs.where(group: @group).first
    return render json: { message: 'No associated fansub' }, status: 400 if @fansub.nil?

    @current = @fansub.current_release
    return render json: { message: 'No pending releases' }, status: 400 if @current.nil?

    if @current.staff.pending.present?
      positions = @current.staff.pending.map(&:user).map(&:name).join(', ')
      return render json: { message: "Positions still pending: #{positions}" }, status: 400
    end

    @current.update_attribute :released, true
    @fansub.current_release&.touch
    render json: { message: "#{@show.name} ##{@current.source.number} released!" }, status: 200
  end
end
