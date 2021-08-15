Rails.application.routes.draw do
  # config/routes/app.rb
  draw  :app

  # config/routes/api.rb
  draw :api

  mount ActionCable.server => '/cable'
end
