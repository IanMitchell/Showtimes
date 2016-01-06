class AddReleasedToRelease < ActiveRecord::Migration
  def change
    remove_column :releases, :status, :integer
    add_column :releases, :released, :boolean, default: false
  end
end
