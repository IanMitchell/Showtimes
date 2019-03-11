# == Schema Information
#
# Table name: releases
#
#  id         :integer          not null, primary key
#  fansub_id  :integer
#  category   :integer          default("tv")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  released   :boolean          default(FALSE)
#  episode_id :bigint(8)
#

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
