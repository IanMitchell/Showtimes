class StaffController < ApplicationController
  include DiscordHelper

  before_action :require_authorization, only: [:update]

  def update
    fin = ActiveRecord::Type::Boolean.new.deserialize(params[:status])

    @group = Channel.find_by(name: params[:channel] || params[:irc],
                             platform: Channel.from_platform(params[:platform]),
                             staff: true)&.group
    return render json: { message: 'Unknown channel' }, status: 400 if @group.nil?

    @user = Account.find_by(name: params[:username],
                            platform: Account.from_platform(params[:platform]))&.user
    return render json: { message: 'Unknown user.' }, status: 400 if @user.nil?

    shows = @group.fuzzy_search_subbed_shows(params[:name])
    case shows.length
    when 0
      return render json: { message: 'Unknown show.' }, status: 400
    when 1
      @show = shows.first
    else
      names = shows.map { |show| show.name }.to_sentence
      return render json: { message: "Multiple Matches: #{names}" }, status: 400
    end

    @staff = @show.fansubs.includes(:groups)
                          .where(groups: { id: @group.id })
                          &.first
                          &.current_release
                          &.staff
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
