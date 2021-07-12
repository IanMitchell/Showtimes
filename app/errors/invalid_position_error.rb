class InvalidPositionError < StandardError
  def status
    400
  end

  def message
    "That's not your position!"
  end
end
