class FansubFinishedError < StandardError
  def status
    400
  end

  def message
    "The fansub is complete!"
  end
end
