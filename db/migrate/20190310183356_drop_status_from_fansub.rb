class DropStatusFromFansub < ActiveRecord::Migration[5.2]
  def change
    remove_column :fansubs, :status
  end
end
