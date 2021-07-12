class PendingPositionError < StandardError
  def status
    400
  end
end
