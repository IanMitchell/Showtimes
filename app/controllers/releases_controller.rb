class ReleasesController < ApplicationController
  def show
    # @release = Release.find(params[:id])
    redirect_to group_path(Group.first)
  end

  def update
    if params[:auth].eql? 'secretpassword'
      @group = Group.where('lower(staff_irc) = ?', params[:irc].downcase).first

      if @group.nil?
        render json: { message: 'Unknown IRC channel' }, status: 400
        return
      end

      @show = Show.where('lower(name) = ?', params[:name].downcase).first

      if @show.nil?
        render json: { message: 'Unknown show.' }, status: 400
        return
      end

      @current = @show.fansubs.where(group: @group).first.current_release

      if @current.nil?
        render json: { message: 'No pending releases' }, status: 400
        return
      end

      @current.update_attribute :status, :released
      render json: { message: "Updated #{params[:show]}" }, status: 200
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
