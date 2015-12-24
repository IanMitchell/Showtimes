class StaffController < ApplicationController
  def update
    # TODO: Update passphrase and move to ENV variable
    if params[:auth].eql? 'secretpassword'
      @group = Group.where('lower(irc) = ?', params[:irc].downcase).first

      if @group.nil?
        render json: { message: 'Unknown IRC channel' }, status: 400
        return
      else
        logger.info @group.name
      end

      @user = User.find_by(name: params[:username])

      if @user.nil?
        render json: { message: 'Unknown user; please use main IRC nick' }, status: 400
        return
      else
        logger.info @user.name
      end

      @show = Show.where('lower(name) = ?', params[:name].downcase).first

      if @show.nil?
        render json: { message: 'Unknown show.' }, status: 400
        return
      end

      @staff = @show.fansubs.where(group: @group).first.
                     current_release.staff.where(user: @user)

      if params[:position]
        @position = Position.where('lower(name) = ?', params[:position].downcase).first
        if @position.nil?
          render json: { message: 'Invalid position.' }, status: 400
          return
        end

        @staff = @staff.where(position: @position).first
      else
        if @staff.count > 1
          render json: { message: 'Please specify position' }, status: 400
          return
        else
          @staff = @staff.first
        end
      end

      if [:pending, :finished].include? params[:status].to_sym
        @staff.update_attribute :status, params[:status].to_sym
        render json: { message: "Updated #{params[:name]}" }, status: 200
      else
        render json: { message: 'Invalid; Use `pending` or `finished`' }, status: 400
      end
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
