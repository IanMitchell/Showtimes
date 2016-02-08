class ShowsController < ApplicationController
  def index
    # TODO: Limit by channel
    @shows = Show.where(season: Season.current)
    return render(json: { message: "Unknown Season" }, status: 404) if @shows.nil?
  end

  def show
    # TODO: Limit by channel?
    @show = Show.find_by_name_or_alias(params[:id])
    return render(json: { message: 'Unknown Show' }, status: 404) if @show.nil?
  end
end
