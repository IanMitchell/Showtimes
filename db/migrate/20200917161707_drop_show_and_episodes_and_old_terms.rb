class DropShowAndEpisodesAndOldTerms < ActiveRecord::Migration[6.0]
  def change
    Term.all.each do |term|
      term.destroy if term.fansub_id.nil? && term.show_id != nil
    end
    
    drop_table :shows
    drop_table :episodes
  end
end
