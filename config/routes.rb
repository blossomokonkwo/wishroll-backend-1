Rails.application.routes.draw do

  resources :posts, except: [:update] do
    resources :comments
    resources :tags, only: [:create, :destroy]
  end
    


  #user account update routes
  patch 'user/password', to: "users#update_password"
  patch 'user/username', to: "users#update_username"
  patch 'user/picture', to: "users#update_profile_picture"
  patch 'user/name',   to: "users#update_name"
  patch 'user/bio',     to: "users#update_bio"

  #the delete account endpoint. Before the users account is destroyed make sure to flush the users session data and tokens.
  delete 'user/delete', to: "users#destroy"

  
  

  #the follow/unfollow endpoints
  post 'follow/:username', to: "relationships#create"
  delete 'unfollow/:username', to: "relationships#destroy"

  get 'feed', to: "feed#index"
  get 'trending', to: "trending#trending"
  post 'search', to: "search#search"
  delete 'logout', to: "logout#destroy" #the logout route
  post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
  post 'login', to: "login#create" #the login 
  

  #registration flow
  post 'signup/email', to: "signup#validate_email"
  post 'signup/username', to: "signup#validate_username"
  post 'signup', to: "signup#new" #the signup route 

  #this url allows users to view the account data of other users. Users are found via the username extension
  get ':username', to: "users#show"
end
