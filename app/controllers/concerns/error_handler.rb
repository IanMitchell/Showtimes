module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from UnauthorizedError, with: :render_exception_response

    rescue_from GroupNotFoundError, with: :render_exception_response
    rescue_from FansubNotFoundError, with: :render_exception_response
    rescue_from PositionNotFoundError, with: :render_exception_response

    rescue_from InvalidPositionError, with: :render_exception_response
    rescue_from EpisodeUnairedError, with: :render_exception_response
    rescue_from PendingPositionError, with: :render_exception_response
    rescue_from FansubFinishedError, with: :render_exception_response
    rescue_from MultipleMatchingFansubsError, with: :render_exception_response
  end

  def render_exception_response(exception)
    render_error exception.status, exception.message
  end

  def render_error(status, message)
    render json: { message: message },
           status: status
  end
end
