require "#{Rails.root}/lib/errors/fansub_finished_error"
require "#{Rails.root}/lib/errors/multiple_matching_shows_error"
require "#{Rails.root}/lib/errors/fansub_not_found_error"
require "#{Rails.root}/lib/errors/group_not_found_error"
require "#{Rails.root}/lib/errors/member_not_found_error"
require "#{Rails.root}/lib/errors/show_not_found_error"
require "#{Rails.root}/lib/errors/position_not_found_error"

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::GroupNotFoundError, with: :unknown_group
    rescue_from Errors::FansubNotFoundError, with: :unknown_fansub
    rescue_from Errors::ShowNotFoundError, with: :unknown_show
    rescue_from Errors::MemberNotFoundError, with: :unknown_member
    rescue_from Errors::PositionNotFoundError, with: :unknown_position

    rescue_from Errors::FansubFinishedError, with: :fansub_finished
    rescue_from Errors::MultipleMatchingShowsError, with: :multiple_shows
  end

  def render_error(status, message)
    render json: { message: message },
           status: status
  end

  def unknown_group
    render_error 404, "Unknown Discord server. If you'd like to use Showtimes, please contact Desch#3091"
  end

  def unknown_member
    render_error 404, "Unknown user. If you're a new fansubber, have a group admin authorize you"
  end

  def unknown_position
    render_error 400, "Invalid position."
  end

  def fansub_finished(exception)
    render_error 400, exception.message
  end

  def unknown_fansub
    render_error 400, 'No associated fansub'
  end

  def unknown_show
    render_error 404, 'Unknown show'
  end

  def multiple_shows(exception)
    render_error 400, exception.message
  end
end
