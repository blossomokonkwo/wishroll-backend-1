namespace :analytics do 
    resources :visits, only: [:create]
  end