class BlameController < ApplicationController
  def show
    @group = Channel.find_by(name: params[:channel] || params[:irc],
                             platform: Channel.from_platform(params[:platform]))&.group
    return render json: { message: 'Unknown channel' }, status: 400 if @group.nil?

    shows = @group.fuzzy_search_subbed_shows(params[:show])
    case shows.length
    when 0
      unless Show.fuzzy_search(params[:show]).present?
        return render json: { message: 'Unknown show.' }, status: 400
      end
    when 1
      @show = shows.first
    else
      names = shows.map { |show| show.name }.to_sentence
      return render json: { message: "Multiple Matches: #{names}" }, status: 400
    end

    @fansub = @group.fansubs.where(show: @show).where.not(status: 3).first
    return render json: { message: 'No associated fansub' }, status: 400 if @fansub.nil?

    @release = @fansub.current_release
    return render json: { message: 'The fansub is complete!' }, status: 200 if @release.nil?
  end
end
