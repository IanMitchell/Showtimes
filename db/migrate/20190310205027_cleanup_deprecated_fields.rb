class CleanupDeprecatedFields < ActiveRecord::Migration[5.2]
  def up
    remove_column :channels, :staff
    remove_column :channels, :platform

    remove_column :fansubs, :tag, :string
    remove_column :fansubs, :status

    remove_column :members, :role
    remove_column :members, :title
    remove_column :members, :active
    remove_column :members, :user_id
    remove_column :members, :group_id

    remove_column :staff, :user_id

    remove_column :releases, :station_id

    drop_table :accounts
    drop_table :users
    drop_table :stations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
