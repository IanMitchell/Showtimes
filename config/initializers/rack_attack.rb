class Rack::Attack
  blocklist = [
    '187.109.85.234',
    '179.216.235.85',
    '37.16.81.241'
  ]

  Rack::Attack.blocklist('IP Blocks') do |req|
    req.ip.in? blocklist
  end

  # Throttle requests to 5 requests per second per ip
  Rack::Attack.throttle('req/ip', limit: 10, period: 1.second) do |req|
    # If the return value is truthy, the cache key for the return value
    # is incremented and compared with the limit. In this case:
    #   "rack::attack:#{Time.now.to_i/1.second}:req/ip:#{req.ip}"
    #
    # If falsy, the cache key is neither incremented nor checked.
    req.ip
  end
end
