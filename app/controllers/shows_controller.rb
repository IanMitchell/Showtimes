class ShowsController < ApplicationController
  include Concerns::ErrorHandler

  def index
    @group = Group.find_by_discord(params[:channel])
    @shows = @group.airing_shows
  end

  def show
    @show = Show.fuzzy_find(params[:id])
  end
end
