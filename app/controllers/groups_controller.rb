class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.friendly.find(params[:id])
  end
end
