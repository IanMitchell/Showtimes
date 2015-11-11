class GroupsController < ApplicationController
  def index
    # @groups = Group.all
    redirect_to group_path(Group.first)
  end

  def show
    @group = Group.friendly.find(params[:id])
  end
end
