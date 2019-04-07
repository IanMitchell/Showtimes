class RenameAliasToTerm < ActiveRecord::Migration[5.2]
  def change
    rename_table :aliases, :terms
  end
end
