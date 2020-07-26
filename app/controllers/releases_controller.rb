class ReleasesController < ApplicationController
  include ErrorHandler

  before_action :require_authorization, only: [:update]

  def update
    @group = Group.find_by_discord(params[:channel])
    @user = @group.find_member(params[:username])

    @fansub = @group.find_fansub_for_show_fuzzy(URI.decode_www_form_component(params[:name]))
    @current = @fansub.current_release

    if @current.staff.pending.present?
      positions = @current.staff.pending.map(&:member).map(&:name).join(', ')
      return render json: { message: "Positions still pending: #{positions}" }, status: 400
    end

    @current.update_attribute :released, true

    @fansub.notify_release(@current)

    render json: { message: "#{@fansub.show.name} ##{@current.episode.number} released!" }, status: 200
  end
end
