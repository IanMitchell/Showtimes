class AddReleasedIndexToRelease < ActiveRecord::Migration[5.2]
  def change
    add_index :releases, :released
  end
end
