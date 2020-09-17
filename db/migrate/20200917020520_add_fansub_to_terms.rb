class AddFansubToTerms < ActiveRecord::Migration[6.0]
  def up
    add_reference :terms, :fansub, index: true, foreign_key: true
    
    Term.all.each do |term|
      term.show.fansubs.each do |fansub|
        Term.create(name: term.name, fansub: fansub)
      end
    end
  end
end
