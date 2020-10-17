class ReleasesController < ApplicationController
  include ErrorHandler

  before_action :authorize_group, only: [:update]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error 404,
                 "You aren't a group member! If you're new, have a group admin authorize you"
  end

  def update
    @user = @group.members.find_by!(discord: params[:username])
    @fansub = @group.find_fansub_by_name_fuzzy_search(URI.decode_www_form_component(params[:name]))
    raise FansubFinishedError if @fansub.finished?

    @current = @fansub.current_release

    if @current.positions_pending?
      raise PendingPositionError, "Positions still pending: #{@current.position_pending_list}"
    end

    @current.update_attribute :released, true

    @fansub.notify_release(@current)
    render json: { message: "#{@fansub.name} ##{@current.number} released!" }, status: 200
  end
end
