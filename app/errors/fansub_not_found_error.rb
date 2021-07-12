class FansubNotFoundError < StandardError
  def status
    400
  end

  def message
    "No associated fansub"
  end
end
