class ShowsController < ApplicationController
  include ErrorHandler

  def index
    @group = Group.find_by_discord(params[:discord])
    @shows = @group.fansubs.airing.visible
  end
end
