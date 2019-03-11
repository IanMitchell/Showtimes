# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  show_id    :integer
#  number     :integer
#  air_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  season     :integer
#  year       :integer
#

require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
