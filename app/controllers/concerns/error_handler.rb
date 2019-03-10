module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Showtimes::GroupNotFoundError, with: :unknown_group
    rescue_from Showtimes::FansubFinishedError, with: :fansub_finished
    rescue_from Showtimes::FansubNotFoundError, with: :unknown_fansub
    rescue_from Showtimes::ShowNotFoundError, with: :unknown_show
    rescue_from Showtimes::MultipleMatchingShows, with: :multiple_shows
  end

  def render_error(status, message)
    render json: { message: message },
           status: status
  end

  def unknown_group
    render_error 404, "Unknown Discord server. If you'd like to use Showtimes, please contact Desch#3091",
  end

  def fansub_finished
    render_error 200, 'The fansub is complete!'
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
