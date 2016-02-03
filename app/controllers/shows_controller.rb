class ShowsController < ApplicationController
  def index
    # TODO: Limit by channel
    @shows = Show.where(season: Season.current)
  end

  def show
    # TODO: Limit by channel?
    @show = Show.find_by_name_or_alias(params[:id])
  end
end
