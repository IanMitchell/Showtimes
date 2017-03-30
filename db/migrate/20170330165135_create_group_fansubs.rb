class CreateGroupFansubs < ActiveRecord::Migration
  def change
    create_table :group_fansubs do |t|
      t.references :group, index: true, foreign_key: true
      t.references :fansub, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
