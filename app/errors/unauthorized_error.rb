class UnauthorizedError < StandardError
  def status
    401
  end

  def message
    "Invalid Token"
  end
end
