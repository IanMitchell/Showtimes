class ShowsController < ApplicationController
  def index
    @group = Channel.find_by(name: params[:irc])&.group
    return render json: { message: 'Unknown IRC channel' }, status: 400 if @group.nil?

    @shows = Show.joins(:fansubs).where(season: Season.current,
                                        fansubs: {
                                          group: @group,
                                          status: Fansub.statuses[:active]
                                        })
  end

  def show
    # TODO: Limit by channel?
    @show = Show.find_by_name_or_alias(params[:id])
    return render(json: { message: 'Unknown Show' }, status: 404) if @show.nil?
  end
end
