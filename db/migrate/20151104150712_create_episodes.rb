class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.references :show, index: true, foreign_key: true
      t.references :volume, index: true, foreign_key: true
      t.integer :number
      t.datetime :air_date

      t.timestamps null: false
    end
  end
end
