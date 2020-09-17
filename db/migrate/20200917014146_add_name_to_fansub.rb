class AddNameToFansub < ActiveRecord::Migration[6.0]
  def up
    add_column :fansubs, :name, :string, index: true

    Fansub.all.each do |fansub|
      fansub.update! name: fansub.show.name
    end
  end

  def down
    remove_column :fansubs, :name
  end
end
