class StaffController < ApplicationController
  def update
    # TODO: Update passphrase and move to ENV variable
    if params[:auth].eql? 'secretpassword'
      @staff = Show.find_by(name: params[:name])
                .fansubs.where(group: Group.find_by(irc: params[:irc])).first
                .current_release.staff
                .where(user: User.find_by(name: params[:username])).first

      if [:pending, :finished].include? params[:status].to_sym
        @staff.update_attribute :status, params[:status].to_sym
        render json: { message: "Updated #{params[:name]}" }, status: 200
      else
        render json: { message: 'Invalid; Use `pending` or `finished`' }, status: 400
      end
    else
      render json: { message: 'Unauthorized Request' }, status: 401
    end
  end
end
