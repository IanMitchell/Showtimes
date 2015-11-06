class CreateFansubs < ActiveRecord::Migration
  def change
    create_table :fansubs do |t|
      t.references :group, index: true, foreign_key: true
      t.references :show, index: true, foreign_key: true
      t.string :tag
      t.string :nyaa_link
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
