class ShowsController < ApplicationController
  def index
    @group = Channel.find_by(name: params[:channel] || params[:irc],
                             platform: Channel.from_platform(params[:platform]))&.group
    return render json: { message: 'Unknown channel' }, status: 400 if @group.nil?

    @shows = @group.airing_shows
  end

  def show
    # TODO: Limit by channel?
    shows = Show.fuzzy_search(params[:id])
    case shows.length
    when 0
      return render json: { message: 'Unknown show.' }, status: 404
    when 1
      @show = shows.first
    else
      names = shows.map { |show| show.name }.to_sentence
      return render json: { message: "Multiple Matches: #{names}" }, status: 400
    end
  end
end
