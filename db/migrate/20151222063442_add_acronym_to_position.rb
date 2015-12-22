class AddAcronymToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :acronym, :string
  end
end
