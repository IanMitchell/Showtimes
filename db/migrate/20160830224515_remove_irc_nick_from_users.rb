class RemoveIrcNickFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :irc_nick, :string
  end
end
