# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  air_date   :datetime
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_episodes_on_show_id  (show_id)
#

require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
