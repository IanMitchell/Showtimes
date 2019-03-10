class RemoveTagFromFansubs < ActiveRecord::Migration[5.2]
  def change
    remove_column :fansubs, :tag, :string
  end
end
