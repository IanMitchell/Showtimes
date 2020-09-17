# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  discord    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null
#
# Indexes
#
#  index_channels_on_discord   (discord)
#  index_channels_on_group_id  (group_id)
#

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
