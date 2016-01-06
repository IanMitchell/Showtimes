class AddActiveToMember < ActiveRecord::Migration
  def change
    remove_column :members, :status, :integer
    add_column :members, :active, :boolean, default: true
  end
end
