class UnstaffedReleaseError < StandardError
  def status
    400
  end
end
