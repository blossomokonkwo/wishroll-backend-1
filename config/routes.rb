Rails.application.routes.draw do
  # config/routes/app.rb
  draw  :app

  # config/routes/api.rb
  draw :api

  # config/routes/analytics.rb
  draw :analytics

  # config/routes/admin.rb
  draw :admin

  mount ActionCable.server => '/cable'
end
