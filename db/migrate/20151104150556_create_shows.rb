class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.references :season, index: true, foreign_key: true
      t.string :name
      t.string :link

      t.timestamps null: false
    end
  end
end
