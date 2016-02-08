class ReleasesController < ApplicationController
  def show
    # @release = Release.find(params[:id])
    redirect_to group_path(Group.first)
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

      @current.update_attribute :released, true
      render json: { message: "#{@show.name} ##{@current.source.number} has been released!" }, status: 200
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
