
Predictor.redis = Redis.new(url: ENV['PREDICTOR_REDIS_URL']) if Rails.env.production?
Predictor.redis = Redis.new if Rails.env.development?