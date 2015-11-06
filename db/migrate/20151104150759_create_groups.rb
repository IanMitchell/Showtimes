class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :acronym
      t.string :irc

      t.timestamps null: false
    end
  end
end
