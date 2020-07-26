class BlameController < ApplicationController
  include ErrorHandler

  def show
    @group = Group.find_by_discord(params[:channel])
    @fansub = @group.find_fansub_for_show_prioritized_fuzzy(URI.decode_www_form_component(params[:show]))
    @release = @fansub.current_release
  end
end
