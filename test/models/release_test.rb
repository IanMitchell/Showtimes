# == Schema Information
#
# Table name: releases
#
#  id         :integer          not null, primary key
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  episode_id :bigint(8)
#  fansub_id  :integer
#
# Indexes
#
#  index_releases_on_episode_id  (episode_id)
#  index_releases_on_fansub_id   (fansub_id)
#

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
