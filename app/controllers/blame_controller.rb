class BlameController < ApplicationController
  include Concerns::ErrorHandler

  def show
    @group = Group.find_by_discord(params[:channel])
    @fansub = @group.find_fansub_for_show_fuzzy(URI.decode(params[:show]))
    @release = @fansub.current_release
  end
end
