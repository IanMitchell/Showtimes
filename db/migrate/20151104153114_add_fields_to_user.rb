class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :irc_nick, :string
    add_column :users, :twitter, :string
    add_column :users, :timezone, :string
  end
end
