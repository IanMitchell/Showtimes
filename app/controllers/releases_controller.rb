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

    @user = User.includes(:members).includes(:accounts)
                .where(members: { group_id: @group.id },
                       accounts: { name: params[:username] })
                &.first

    return render json: { message: 'Unknown member' }, status: 400 if @user.nil?

    shows = @group.fuzzy_search_subbed_shows(params[:name])
    case shows.length
    when 0
      return render json: { message: 'Unknown Show / No associated fansub.' }, status: 400
    when 1
      @show = shows.first
      @fansub = @show.fansubs.includes(:groups)
                             .where(groups: { id: @group.id })
                             &.first
    else
      names = shows.map { |show| show.name }.to_sentence
      return render json: { message: "Multiple Matches: #{names}" }, status: 400
    end

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
