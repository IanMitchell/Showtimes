class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.references :show, index: true, foreign_key: true
      t.integer :number
      t.datetime :release_date

      t.timestamps null: false
    end
  end
end
