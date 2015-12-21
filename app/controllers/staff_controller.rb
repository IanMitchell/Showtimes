class StaffController < ApplicationController
  def update
    @staff = Show.find_by(name: params[:name])
              .fansubs.where(group: Group.find_by(irc: params[:irc])).first
              .current_release.staff
              .where(user: User.find_by(name: params[:username])).first

    @staff.update_attribute :status, params[:status]
    # TODO: handle errors / return a value
  end
end
