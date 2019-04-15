class StaffController < ApplicationController
  include ErrorHandler

  before_action :require_authorization, only: [:update]

  def update
    fin = ActiveRecord::Type::Boolean.new.deserialize(params[:status])

    @group = Group.find_by_discord(params[:channel])
    @user = @group.find_member(params[:username])
    @fansub = @group.find_fansub_for_show_fuzzy(URI.decode(params[:name]))

    @staff = @fansub.current_release&.staff
    return render json: { message: "No staff for #{@show.name}" }, status: 400 if @staff.empty?

    # Filter by assigned roles unless admin or founder
    @staff = @staff.where(member: @user) unless @user.admin? @group

    # TODO: This is really nasty and needs to be refactored
    if params[:position]
      @position = Position.find_by_name_or_acronym(params[:position])

      @staff = @staff.where(position: @position)
      return render json: { message: "That's not your position!" }, status: 400 if @staff.empty?

      if @staff.count > 1
        # Admin - first, find by own name. If none, or if one and done, then
        staff = @staff.where(member: @user, finished: !fin)
        if staff.present?
          @staff = staff.first
        else
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
      @fansub.notify_update(@fansub.current_release, fin)

      render json: { message: "Updated #{@fansub.show.name} ##{@staff.release.episode.number}" }, status: 200
    else
      render json: { message: "Error updating #{@fansub.show.name}" }, status: 500
    end
  end
end
