class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.references :show, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
