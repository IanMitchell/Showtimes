class Rack::Attack
  blocklist = [
    '187.109.85.234',
    '179.216.235.85',
    '37.16.81.241'
  ]

  blocklist('IP Blocks') do |req|
    req.ip.in? blocklist
  end

  throttle('req/ip', :limit => 10, :period => 1.second) do |req|
    req.ip
  end

  throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      req.ip
    end
  end

  blocklist('fail2ban pentesters') do |req|
    Fail2Ban.filter("pentesters-#{req.ip}",
                    :maxretry => 5,
                    :findtime => 10.minutes,
                    :bantime => 3.hours) do
      req.path == '/users/sign_in' && req.post?
    end
  end
end
