class AddPublicStaffIrcToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :public_irc, :string
    add_column :groups, :staff_irc, :string
    remove_column :groups, :irc, :string
  end
end
