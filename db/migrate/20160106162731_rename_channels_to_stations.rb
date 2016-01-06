class RenameChannelsToStations < ActiveRecord::Migration
  def change
    rename_table :channels, :stations

    remove_column :groups, :public_irc, :string
    remove_column :groups, :staff_irc, :string

    remove_column :releases, :channel_id, :integer
    add_column :releases, :station_id, :integer, :references => 'stations'
    add_index :releases, :station_id

    create_table :channels do |t|
      t.string :name
      t.references :group, index: true, foreign_key: true
      t.boolean :staff, default: false

      t.timestamps null: false
    end
  end
end
