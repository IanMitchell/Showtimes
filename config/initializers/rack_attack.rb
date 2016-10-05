class Rack::Attack
  Rack::Attack.blocklist('block 179.216.235.85') do |req|
    req.ip.eql? '179.216.235.85'
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
