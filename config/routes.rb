Rails.application.routes.draw do
  root to: "feed#index"
  get 'privacy', to: "privacy_policy#privacy"
  get 'terms', to: "terms#terms"
  get 'contact', to: "support#contact"
  get 'home', to: "home#homepage"
  get 'what-is-wishroll', to: "home#whatis"
  constraints subdomain: 'admin' do 
    namespace :admin do
      
      root to: 'admin#index'
      resources :users
      resources :wishlists, only: [:index, :show] do 
        resources :wishes, only: [:index, :show, :destroy]
      end
      resources :posts, except: [:create, :update] do
        delete 'report', to: 'admin/posts#report'
        resources :comments, only: [:destroy, :index, :show]
      end
    end
  end

  resources :wishlists, except: [:update] do
    resources :wishes, except: [:update, :index] 
  end
  
  resources :posts, except: [:update] do
    resources :comments, shallow: true 
    resources :likes, only: [:create, :destroy]
    resources :tags, only: [:create]
  end
  
  #resources for public chatrooms AKA chat rooms that are under a topic 
  resources :topics, except: [:show, :update], shallow: true do 
    resources :chat_rooms, only: [:create, :index, :destroy, :update, :show] do 
      resources :messages, except: [:show]
    end
  end

  #resources for private chat rooms 
  resources :chat_rooms, only: [:index, :create]

  post 'chat_room/:id/appear'. to: "chat_rooms#appear"
  delete 'chat_room/:id/disappear', to: "chat_rooms#disappear"
  post 'chat_room/:id/typing', to: 'chat_rooms#typing'
  delete 'chat_room/:id/not-typing', to: 'chat_rooms#not_typing'

  post 'chat_rooms/:chat_room_id/join', to: "chat_rooms#join" #user is joining a new chat room 
  delete 'chat_rooms/:chat_room_id/leave', to: "chat_rooms#leave" #user is leaving a chat room


  mount ActionCable.server => '/cable'

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

  namespace :v2 do
    get 'search-chats', to: "search_chat_rooms#search"
    resource :device, only: [:create] 
  end
  

  #the follow/unfollow endpoints
  delete 'block', to: 'users#block'
  post 'follow/:username', to: "relationships#create", constraints: {username: /[0-9a-z_.]{1,60}/}
  delete 'unfollow/:username', to: "relationships#destroy", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'following/:username', to: "users#following", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'followers/:username', to: "users#followers", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'trending', to: "trending#trending"
  post 'search', to: "search#search"
  #post 'search-topics-and-chatrooms', to: "search_chat_rooms_and_topics#search" version 3
  delete 'logout', to: "logout#destroy" #the logout route
  post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
  post 'login', to: "login#create" #the login 
  

  #registration flow
  post 'signup/email', to: "signup#validate_email" #this route validates that a user enters an appropriate email that is unique
  post 'signup/username', to: "signup#validate_username" #this route validates a users username for uniqueness and that it matches the regex
  post 'signup', to: "signup#new" #the signup route. This route allows a user to sign up for the service 

  #this route allows users to view the account data of other users. Users are found via the username extension
  get ':username', to: "users#show", constraints: {username: /[0-9a-z_.]{1,60}/}
end
