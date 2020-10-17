class ReleasesController < ApplicationController
  include ErrorHandler

  before_action :authorize_group, only: [:update]

  def update
    @user = @group.members.find_by(discord: params[:username])

    if @user.nil?
      return render json: {
        message: "Unknown user. If you're a new fansubber, have a group admin authorize you"
      },
      status: 404
    end

    @fansub = @group.find_fansub_by_name_fuzzy_search(URI.decode_www_form_component(params[:name]))
    raise FansubFinishedError if @fansub.finished?

    @current = @fansub.current_release

    if @current.staff.pending.present?
      positions = @current.staff.pending.map(&:member).map(&:name).join(', ')
      return render json: { message: "Positions still pending: #{positions}" }, status: 400
    end

    @current.update_attribute :released, true

    @fansub.notify_release(@current)

    render json: { message: "#{@fansub.name} ##{@current.number} released!" }, status: 200
  end
end
