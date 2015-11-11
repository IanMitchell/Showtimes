class HomeController < ApplicationController
  def show
    redirect_to group_path(Group.first)
  end
end
