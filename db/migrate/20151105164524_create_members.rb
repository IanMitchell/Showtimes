class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :group, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :status, default: 0
      t.integer :role, default: 0
      t.string :title

      t.timestamps null: false
    end
  end
end
