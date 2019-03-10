class RemoveTitleActiveAndRoleFromMember < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :role
    remove_column :members, :title
    remove_column :members, :active
  end
end
