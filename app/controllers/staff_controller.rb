class StaffController < ApplicationController
  include ErrorHandler

  before_action :require_authorization, only: [:update]

  def update
    fin = ActiveRecord::Type::Boolean.new.deserialize(params[:status])

    @group = Group.find_by_discord(params[:channel])
    @user = @group.members.find_by(discord: params[:username])

    if @user.nil?
      return render json: {
        message: "Unknown user. If you're a new fansubber, have a group admin authorize you"
      },
      status: 404
    end

    @fansub = @group.find_fansub_by_name_fuzzy_search(URI.decode_www_form_component(params[:name]))

    @staff = @fansub.current_release&.staff
    return render json: { message: "No staff for #{@fansub.name}" }, status: 400 if @staff.empty?

    unless @fansub.current_release.aired?
      return render json:{ message: "The episode has not aired yet!" }, status: 400
    end

    # Filter by assigned roles unless admin or founder
    @staff = @staff.where(member: @user) unless @user.admin?

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

        unless @staff.present?
          return render json: {
            message: "All #{@position.name} positions are marked that way already!"
          }, status: 400
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

    if @staff.nil?
      return render json: {
        message: "Unknown user. If you're a new fansubber (or posting from a different group's Discord), have a group admin authorize you!"
      },
      status: 400
    end

    if @staff.finished == fin
      render json: { message: "It looks like you have already marked your position as #{fin ? 'complete' : 'incomplete'}" }, status: 400
    elsif @staff.update_attribute :finished, fin
      @fansub.notify_update(@fansub.current_release, @staff)
      render json: { message: "Updated #{@fansub.name} ##{@staff.release.number}" }, status: 200
    else
      render json: { message: "Error updating #{@fansub.name}" }, status: 500
    end
  end
end
