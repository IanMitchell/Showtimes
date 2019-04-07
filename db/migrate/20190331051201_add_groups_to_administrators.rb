class AddGroupsToAdministrators < ActiveRecord::Migration[5.2]
  def change
    create_table :administrators_groups do |t|
      t.belongs_to :group, index: true
      t.belongs_to :administrator, index: true
    end
  end
end
