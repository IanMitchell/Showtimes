class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.references :user, index: true, foreign_key: true
      t.references :position, index: true, foreign_key: true
      t.references :release, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
