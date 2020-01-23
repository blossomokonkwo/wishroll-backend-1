Rails.application.routes.draw do
  resources :posts, except: [:update] do
    resources :comments 
    resources :likes, only: [:create, :destroy]
    resources :tags, only: [:create]
  end
  

  #these routes represent the access points for liking app content
  #the params of user_id, likeable_type, and likeable_id must be passed in as JSON from the client
  post "like", to: "likes#create"
  delete "unlike", to: "likes#destroy"

  get 'activities', to: "activities#index"#this route takes the user to their activities feed which details all the activities that effect a users account 
  
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
  post 'signup/email', to: "signup#validate_email" #this route validates that a user enters an appropriate email that is unique
  post 'signup/username', to: "signup#validate_username" #this route validates a users username for uniqueness and that it matches the regex
  post 'signup', to: "signup#new" #the signup route. This route allows a user to sign up for the service 

  #this route allows users to view the account data of other users. Users are found via the username extension
  get ':username', to: "users#show"
end
