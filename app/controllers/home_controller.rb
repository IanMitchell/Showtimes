class HomeController < ApplicationController
  def show
    @groups = Group.all
  end
end
