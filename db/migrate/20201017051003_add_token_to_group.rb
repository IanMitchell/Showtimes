class AddTokenToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :token, :string
    add_index :groups, :token, unique: true

    Group.all.each do |group|
      group.generate_token
    end
  end
end
