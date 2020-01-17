Rails.application.routes.draw do
  resource :user, except: [:create, :index, :destroy] do
    resources :posts, except: [:update], param: :post_id
    resources :tags, only: [:create, :destroy], param: :tag_id
  end
  #user update routes 
  patch 'user/password', to: "users#update_password"
  patch 'user/username', to: "users#update_username"
  patch 'user/picture', to: "users#update_profile_picture"
  patch 'user/name',   to: "users#update_name"
  patch 'user/bio',     to: "users#update_bio"

  resources :comment, except: [:show]

  get 'feed', to: "feed#feed"
  post 'search', to: "search#search"
  get 'posts/:id', to: "posts#show"
  delete 'logout', to: "logout#destroy" #the logout route
  post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
  post 'login', to: "login#create" #the login 
  

  #registration flow
  post 'signup/email', to: "signup#validate_email"
  post 'signup/username', to: "signup#validate_username"
  post 'signup', to: "signup#new" #the signup route 
end
