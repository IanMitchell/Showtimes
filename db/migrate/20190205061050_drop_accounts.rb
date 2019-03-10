class DropAccounts < ActiveRecord::Migration[5.2]
  def up
    User.all.each do |user|
      user.update(discord: User.accounts.where(platform: "discord")&.first&.name)
    end

    drop_table :accounts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
