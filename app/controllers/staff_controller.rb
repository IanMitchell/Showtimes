class StaffController < ApplicationController
  include Concerns::ErrorHandler
  include DiscordHelper

  before_action :require_authorization, only: [:update]

  def update
    fin = ActiveRecord::Type::Boolean.new.deserialize(params[:status])

    @group = Group.find_by_discord(params[:channel])

    @user = User.find_by(discord: params[:username])
    return render json: { message: 'Unknown user.' }, status: 400 if @user.nil?

    @fansub = @group.find_fansub_for_show_fuzzy(URI.decode(params[:show]))

    @staff = @fansub.current_release&.staff
    return render json: { message: "No staff for #{@show.name}" }, status: 400 if @staff.empty?

    # Filter by assigned roles unless admin or founder
    @staff = @staff.where(user: @user) unless @user.group_admin? @group

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
      if @group.webhook?
        discord_update(
          @group.webhook,
          "#{@show.name} ##{@staff.release.episode.number}",
          (@staff.release.staff.map do |staff|
            if staff.finished?
              "~~#{staff.position.acronym}~~"
            else
              "**#{staff.position.acronym}**"
            end
          end.join ' '),
          (fin ? 0x008000 : 0x800000)
        )
      end

      render json: { message: "Updated #{@show.name} ##{@staff.release.episode.number}" }, status: 200
    else
      render json: { message: "Error updating #{@show.name}" }, status: 500
    end
  end
end
