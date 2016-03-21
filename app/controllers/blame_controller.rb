class BlameController < ApplicationController
  def show
    @group = Channel.find_by(name: params[:irc])&.group
    return render json: { message: 'Unknown IRC channel' }, status: 400 if @group.nil?

    @show = Show.find_by_name_or_alias(params[:show])
    return render json: { message: "Unknown Show" }, status: 400 if @show.nil?

    @fansub = @group.fansubs.where(show: @show).first
    return render json: { message: 'No associated fansub' }, status: 400 if @fansub.nil?

    @release = @fansub.current_release
    return render json: { message: 'The fansub is complete!' }, status: 200 if @release.nil?
  end
end
