class StaffController < ApplicationController
  def update
    # TODO: Update passphrase and move to ENV variable
    if params[:auth].eql? 'secretpassword'
      @staff = Show.find_by(name: params[:name])
                .fansubs.where(group: Group.find_by(irc: params[:irc])).first
                .current_release.staff
                .where(user: User.find_by(name: params[:username]))

      if params[:position]
        @staff = @staff.where(position: Position.find_by(acronym: params[:position])).first
      else
        if @staff.count > 1
          render json: { message: 'Please specify position' }, status: 400
          return
        else
          @staff = @staff.first
        end
      end

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
