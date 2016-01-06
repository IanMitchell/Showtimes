class ReleasesController < ApplicationController
  def show
    # @release = Release.find(params[:id])
    redirect_to group_path(Group.first)
  end

  def blame
    # TODO: combine into one line
    @group = Channel.find_by(name: params[:irc])&.group

    if @group.nil?
      render json: { message: 'Unknown IRC channel' }, status: 400
      return
    end

    @show = Show.where('lower(name) = ?', params[:show].downcase).first
    @show ||= Alias.where('lower(name) = ?', params[:show].downcase).first&.show

    if @show.nil?
      render json: { message: "Unknown Show #{params[:show]}" }, status: 400
      return
    end

    @fansub = @group.fansubs.where(show: @show).first

    if @fansub.nil?
      render json: { message: 'This group is not fansubbing that show' }, status: 400
      return
    end

    @release = @fansub.current_release

    if @release.nil?
      render json: { message: 'The fansub is complete!' }, status: 200
      return
    end
  end

  def update
    if params[:auth].eql? 'secretpassword'
      @group = Channel.find_by(name: params[:irc], staff: true)&.group

      if @group.nil?
        render json: { message: 'Unknown IRC channel' }, status: 400
        return
      end

      @show = Show.where('lower(name) = ?', params[:name].downcase).first
      @show ||= Alias.where('lower(name) = ?', params[:name].downcase).first&.show

      if @show.nil?
        render json: { message: 'Unknown show.' }, status: 400
        return
      end

      @current = @show.fansubs.where(group: @group).first.current_release

      if @current.nil?
        render json: { message: 'No pending releases' }, status: 400
        return
      end

      if @current.staff.pending.present?
        positions = @current.staff.pending.map(&:user).map(&:name).join(', ')
        render json: { message: "Positions still pending: #{positions}" }, status: 400
        return
      end

      @current.update_attribute :status, :released
      render json: { message: "Updated #{@show.name}" }, status: 200
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
