# == Schema Information
#
# Table name: releases
#
#  id         :integer          not null, primary key
#  air_date   :datetime         not null
#  number     :integer          not null
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fansub_id  :integer          not null
#
# Indexes
#
#  index_releases_on_air_date   (air_date)
#  index_releases_on_fansub_id  (fansub_id)
#  index_releases_on_number     (number)
#  index_releases_on_released   (released)
#

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
