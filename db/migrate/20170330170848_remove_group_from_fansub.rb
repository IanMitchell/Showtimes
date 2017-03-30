class RemoveGroupFromFansub < ActiveRecord::Migration
  def change
    remove_reference :fansubs, :group, index: true
  end
end
