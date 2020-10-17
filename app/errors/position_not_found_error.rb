class PositionNotFoundError < StandardError
  def status
    400
  end

  def message
    "Invalid position."
  end
end
