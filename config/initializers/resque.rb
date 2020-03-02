require 'resque/server'
rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..' #Sets rails_root to the root directory of app
rails_env = ENV['RAILS_ENV'] || 'development' #Gets the currnet environment, or default to development  
resque_config = YAML.load_file(rails_root + '/config/resque.yml')
uri = URI.parse(resque_config[rails_env])
if rails_env === 'development'  
	Resque.redis = Redis.new(host: uri.host, port: uri.port)  
elsif rails_env === 'production'  
	resque_password = ENV['RESQUE_PASSWORD']
	Resque.redis = Redis.new(url: ENV['REDISCLOUD_URL'], password: resque_password)  
end  