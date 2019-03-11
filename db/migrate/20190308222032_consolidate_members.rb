class ConsolidateMembers < ActiveRecord::Migration[5.2]
  # There is a corresponding file in `lib/tasks/migrations` for this
  def change
    add_reference :staff, :member, index: true
    add_column :members, :name, :string
    add_column :members, :discord, :string

    create_table :group_members do |t|
      t.belongs_to :group, index: true
      t.belongs_to :member, index: true
      t.boolean :admin, default: false
    end
  end
end
