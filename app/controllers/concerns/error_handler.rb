module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from UnauthorizedError, with: :render_error_response
    rescue_from GroupNotFoundError, with: :render_error_response
    rescue_from FansubNotFoundError, with: :render_error_response
    rescue_from PositionNotFoundError, with: :render_error_response

    rescue_from FansubFinishedError, with: :render_error_response
    rescue_from MultipleMatchingFansubsError, with: :render_error_response
  end

  def render_error_response(exception)
    render json: { message: exception.message },
           status: exception.status
  end
end
