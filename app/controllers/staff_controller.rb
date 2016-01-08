class StaffController < ApplicationController
  def update
    # TODO: Update passphrase and move to ENV variable
    if params[:auth].eql? 'secretpassword'
      fin = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:status])

      @group = Channel.find_by(name: params[:irc], staff: true)&.group

      if @group.nil?
        render json: { message: 'Unknown IRC channel' }, status: 400
        return
      end

      @user = User.find_by(name: params[:username])

      if @user.nil?
        render json: { message: 'Unknown user; please use main IRC nick' }, status: 400
        return
      end

      @show = Show.where('lower(name) = ?', params[:name].downcase).first
      @show ||= Alias.where('lower(name) = ?', params[:name].downcase).first&.show

      if @show.nil?
        render json: { message: 'Unknown show.' }, status: 400
        return
      end

      if @user.members.where(group: @group).first.founder?
        @staff = @show.fansubs.where(group: @group).first&.
                       current_release.staff
      else
        @staff = @show.fansubs.where(group: @group).first&.
                       current_release.staff.where(user: @user)
      end

      if @staff.nil?
        render json: { message: "No staff for #{@show.name}" }, status: 400
        return
      end

      if params[:position]
        @position = Position.where('lower(name) = ?', params[:position].downcase).first
        @position ||= Position.where('lower(acronym) = ?', params[:position].downcase).first

        if @position.nil?
          render json: { message: 'Invalid position.' }, status: 400
          return
        end

        @staff = @staff.where(position: @position)

        if @staff.nil?
          render json: { message: "That's not your position!" }, status: 400
          return
        end

        if @staff.count > 1
          # Admin - first, find by own name. If none, or if one and done, then
          staff = @staff.where(user: @user, finished: !fin)
          if staff.present?
            @staff = staff.first
          else
            # TODO: Allow the found to specify a user they're overriding.
            @staff = @staff.where(finished: !fin).first
          end
        else
          @staff = @staff.first
        end
      else
        if @staff.count > 1
          render json: { message: 'Please specify position' }, status: 400
          return
        else
          @staff = @staff.first
        end
      end

      if @staff.update_attribute :finished, fin
        render json: { message: "Updated #{@show.name}" }, status: 200
      else
        render json: { message: "Error updating #{@show.name}" }, status: 500
      end
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
