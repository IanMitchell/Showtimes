class BlameController < ApplicationController
  include ErrorHandler

  def show
    @group = Group.find_by_discord(params[:discord])
    @fansub = @group.find_fansub_by_name_fuzzy_search(URI.decode_www_form_component(params[:show]))
    raise FansubFinishedError if @fansub.finished?

    @release = @fansub.current_release
  end
end
