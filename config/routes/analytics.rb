  scope module: :analytics do
    constraints subdomain: :analytics do
      resources :visits, only: [:create]
    end
  end