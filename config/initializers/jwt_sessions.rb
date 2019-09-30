#This file contains the configuration options for the JWTSessions jem
JWTSessions.encryption_key = "d145400b124ba3875bf39dd7ddb1b84a" #the encryption key
JWTSessions.access_exp_time = 3600 # The access token will be available for one hour
JWTSessions.refresh_exp_time = (604800 * 110) # The refresh token will be available for 2 years
JWTSessions.token_store = :redis, {
    redis_host: "127.0.0.1",
    redis_port: "6379",
    redis_db_name: "0",
    token_prefix: "jwt_"
  }
  