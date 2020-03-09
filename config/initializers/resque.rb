require 'resque/server'
rails_env = ENV['RAILS_ENV'] || 'development' #Gets the currnet environment, or default to development  
uri = URI.parse("localhost:6379")
if rails_env === 'development'  
	Resque.redis = Redis.new(host: uri.host, port: uri.port)  
elsif rails_env === 'production'  
	resque_password = ENV['RESQUE_PASSWORD']
	Resque.redis = Redis.new(url: ENV['REDISCLOUD_URL'], password: resque_password)  
end  