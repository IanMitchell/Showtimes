class RemoveNyaaLinkFromFansubs < ActiveRecord::Migration[5.1]
  def change
    remove_column :fansubs, :nyaa_link, :string
  end
end
