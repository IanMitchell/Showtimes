class StaffController < ApplicationController
  before_action :require_authorization, only: [:update]

  def update
    fin = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:status])

    @group = Channel.find_by(name: params[:irc], staff: true)&.group
    return render json: { message: 'Unknown IRC channel' }, status: 400 if @group.nil?

    @user = User.find_by(name: params[:username])
    return render json: { message: 'Unknown IRC nick' }, status: 400 if @user.nil?

    @show = Show.find_by_name_or_alias(params[:name])
    return render json: { message: 'Unknown show.' }, status: 400 if @show.nil?

    @staff = @show.fansubs.where(group: @group).first&.current_release&.staff
    @staff = @staff.where(user: @user) unless @user.members.where(group: @group).first.founder?
    return render json: { message: "No staff for #{@show.name}" }, status: 400 if @staff.nil?

    if params[:position]
      @position = Position.find_by_name_or_acronym(params[:position])
      return render json: { message: 'Invalid position.' }, status: 400 if @position.nil?

      @staff = @staff.where(position: @position)
      return render json: { message: "That's not your position!" }, status: 400 if @staff.empty?

      if @staff.count > 1
        # Admin - first, find by own name. If none, or if one and done, then
        staff = @staff.where(user: @user, finished: !fin)
        if staff.present?
          @staff = staff.first
        else
          # TODO: Allow the founder to specify a user they're overriding.
          @staff = @staff.where(finished: !fin).first
        end
      else
        @staff = @staff.first
      end
    else
      if @staff.count > 1
        return render json: { message: 'Please specify position' }, status: 400
      else
        @staff = @staff.first
      end
    end

    if @staff.update_attribute :finished, fin
      render json: { message: "Updated #{@show.name} ##{@staff.release.source.number}" }, status: 200
    else
      render json: { message: "Error updating #{@show.name}" }, status: 500
    end
  end
end
