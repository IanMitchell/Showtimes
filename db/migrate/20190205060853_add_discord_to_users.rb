class AddDiscordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :discord, :string
  end
end
