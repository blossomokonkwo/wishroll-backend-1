web: bin/heroku-web
worker: bundle exec sidekiq -C config/sidekiq.yml

 rpush: bundle exec rpush start -e $RACK_ENV -f
