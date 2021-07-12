class GroupNotFoundError < StandardError
  def status
    404
  end

  def message
    "Unknown Discord server. If you'd like to use Showtimes, please contact Desch#3091"
  end
end
