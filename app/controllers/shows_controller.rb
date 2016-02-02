class ShowsController < ApplicationController
  def index
    @shows = Show.where(season: Season.current)
  end

  def show
  end
end
