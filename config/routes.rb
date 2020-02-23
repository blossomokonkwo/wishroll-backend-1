Rails.application.routes.draw do
  root to: "feed#index"
  get 'privacy', to: "privacy_policy#privacy"
  get 'terms', to: "terms#terms"
  get 'contact', to: "support#contact"
  get 'home', to: "home#home"
  get 'what-is-wishroll', to: "home#what_is_wishroll"
  namespace :admin do 
    resources :users
    resources :wishlists, only: [:index, :show] do 
      resources :wishes, only: [:index, :show, :destroy]
    end
    resources :posts, except: [:create, :update] do
      resources :comments, only: [:destroy, :index, :show]
    end
  end

  resources :wishlists, except: [:update] do
    resources :wishes, except: [:update, :index] 
  end
  
  put "wishes/update-wish-picture/:id", to: 'wishes#update_wish_picture'
  put "wishes/update-wish-description/:id", to: 'wishes#update_wish_description'
  put "wishes/update-product-name/:id", to: 'wishes#update_product_name'
  put "wishlists/update-wishlist-name/:id", to: 'wishlists#update_wishlist_name'
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
  put 'user/update-password', to: "users#update_password"
  put 'user/update', to: "users#update"

  #the delete account endpoint. Before the users account is destroyed make sure to flush the users session data and tokens.
  delete 'user/delete', to: "users#destroy"

  
  

  #the follow/unfollow endpoints
  post 'follow/:username', to: "relationships#create"
  delete 'unfollow/:username', to: "relationships#destroy"
  get 'following/:username', to: "users#following"
  get 'followers/:username', to: "users#followers"
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
  get ':username', to: "users#show", constraints: {username: /[0-9a-z_.]{1,20}/}
end
