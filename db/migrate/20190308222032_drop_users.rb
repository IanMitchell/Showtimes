class DropUsers < ActiveRecord::Migration[5.2]
  def up
    add_reference :staff, :memberr, index: true
    add_column :members, :name, :string
    add_column :members, :discord, :string


    # Add Name to Members
    # Add Discord to Members
    # Migrate from linked User
    # Migrate Staff user to Member

    remove_column :members, :user_id
    remove_column :staff, :user_id

    drop_table :users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
