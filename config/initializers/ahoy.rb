class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true
Ahoy.api_only = true
Ahoy.mask_ips = true
Ahoy.cookies = false
Ahoy.quiet = false
Ahoy.geocode = false
Ahoy.job_queue = :high_priority