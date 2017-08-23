class DropVolumes < ActiveRecord::Migration[5.1]
  def up
    remove_column :episodes, :volume_id
    drop_table :volumes

    change_table :releases do |t|
      t.references :episode
    end

    say "Updating Release Table..."
    Release.all.each do |release|
      release.update_column(:episode_id, release.source_id)
    end

    remove_column :releases, :source_id
    remove_column :releases, :source_type
  end

  def down
    create_table :volumes do |t|
      t.references :show, index: true, foreign_key: true
      t.integer :number
      t.datetime :release_date

      t.timestamps null: false
    end

    change_table :episodes do |t|
      t.references :volume
    end

    change_table :releases do |t|
      t.references :source, polymorphic: true, index: true
    end

    say "Updating Release Table..."
    Release.all.each do |release|
      release.update_column(:source_id, release.episode_id)
    end

    remove_column :releases, :episode_id
  end
end
