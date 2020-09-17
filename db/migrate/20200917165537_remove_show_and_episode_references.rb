class RemoveShowAndEpisodeReferences < ActiveRecord::Migration[6.0]
  def change
    remove_column :terms, :show_id
    change_column_null :terms, :fansub_id, false
    change_column_null :terms, :name, false
    
    remove_column :fansubs, :show_id
    change_column_null :fansubs, :name, false
    
    change_column_null :group_fansubs, :fansub_id, false
    change_column_null :group_fansubs, :group_id, false
    
    change_column_null :group_members, :group_id, false
    change_column_null :group_members, :member_id, false
    
    change_column_null :groups, :acronym, false
    change_column_null :groups, :name, false
    
    change_column_null :members, :discord, false
    change_column_null :members, :name, false
    
    change_column_null :positions, :acronym, false
    change_column_null :positions, :name, false
    
    remove_column :releases, :episode_id
    change_column_null :releases, :fansub_id, false
    change_column_null :releases, :number, false
    change_column_null :releases, :air_date, false
    
    change_column_null :channels, :group_id, false
    change_column_null :channels, :discord, false
  end
end
