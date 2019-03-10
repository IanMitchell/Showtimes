class GroupsController < ApplicationController
  def show
    @group = Group.friendly.find(params[:id])
  end
end
