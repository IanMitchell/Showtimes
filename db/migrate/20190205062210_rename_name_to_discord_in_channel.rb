class RenameNameToDiscordInChannel < ActiveRecord::Migration[5.2]
  def change
    rename_column :channels, :name, :discord
  end
end
