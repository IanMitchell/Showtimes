class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  private

    def require_authorization
      unless params[:auth].eql? ENV['AUTH']
        return render json: { message: 'Unauthorized Request' }, status: 401
      end
    end
end
