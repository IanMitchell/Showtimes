class BlameController < ApplicationController
  include ErrorHandler

  def show
    @group = Group.find_by_discord(params[:channel])
    @fansub = @group.find_fansub_by_name_fuzzy_search(URI.decode_www_form_component(params[:show]))

    if @fansub.finished?
      raise FansubFinishedError, "The fansub for #{@fansub.name} is complete!"
    end

    @release = @fansub.current_release
  end
end
