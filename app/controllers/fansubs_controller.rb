class FansubsController < ApplicationController
  def show
    # @fansub = Fansub.find(params[:id])
    redirect_to group_path(Group.first)
  end
end
