class EpisodeUnairedError < StandardError
  def status
    400
  end

  def message
    "The episode has not aired yet!"
  end
end
