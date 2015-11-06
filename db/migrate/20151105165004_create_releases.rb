class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.references :fansub, index: true, foreign_key: true
      t.references :channel, index: true, foreign_key: true
      t.references :source, polymorphic: true, index: true
      t.integer :status, default: 0
      t.integer :category, default: 0

      t.timestamps null: false
    end
  end
end
