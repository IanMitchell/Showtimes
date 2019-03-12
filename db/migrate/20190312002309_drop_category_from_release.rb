class DropCategoryFromRelease < ActiveRecord::Migration[5.2]
  def change
    remove_column :releases, :category
  end
end
