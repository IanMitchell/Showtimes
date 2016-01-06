class AddFinishedToStaff < ActiveRecord::Migration
  def change
    remove_column :staff, :status, :integer
    add_column :staff, :finished, :boolean, default: false
  end
end
