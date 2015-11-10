class FansubsController < ApplicationController
  def show
    @fansub = Fansub.find(params[:id])
  end
end
