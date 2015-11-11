class ReleasesController < ApplicationController
  def show
    # @release = Release.find(params[:id])
    redirect_to group_path(Group.first)
  end
end
