class AddFinishedIndexToStaff < ActiveRecord::Migration[5.2]
  def change
    add_index :staff, :finished
  end
end
