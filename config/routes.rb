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

  post 'chat_room/:id/appear', to: "chat_rooms#appear"
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
    namespace :search do
      get 'posts', to: 'posts#search'
      get 'users', to: 'users#search'
      get 'relationships', to: 'relationships#search'
      get 'rolls', to: 'rolls#search'
    end
    namespace :trending do
      get 'posts', to: 'posts#trending'
      get 'rolls', to: 'rolls#trending'
      get 'topics', to: 'topics#trending'
    end
    namespace :feed do
      get 'posts', to: 'posts#feed'
      get 'rolls', to: 'rolls#feed'
    end
    namespace :recommendation do
      get 'posts/:post_id', to: 'posts#recommend'
      get 'rolls/:roll_id', to: 'rolls#recommend'
    end
    resources :rolls do
      resources :comments, shallow: true do
        resources :likes, shallow: true
      end
      resources :shares, only: [:create, :index]
      resources :likes, shallow: true
      resources :tags, shallow: true
      resources :bookmarks, shallow: true
    end
    resources :posts, only: [:show, :update, :create, :destroy] do
      resources :comments, shallow: true do
        resources :likes, shallow: true
      end
      resources :shares, only: [:create, :index]
      resources :likes, shallow: true
      resources :tags, shallow: true
      resources :bookmarks, shallow: true
    end
    
    resources :users, only: [:update, :show] do
      resources :albums, shallow: true
      resources :bookmarks, only: [:index]
    end

    resources :chat_rooms, only: [:index, :create, :update] do
      resources :messages, shallow: true
      resources :chat_room_users
    end

    post 'chat_rooms/:id/appear', to: "chat_room_users#appear"
    delete 'chat_rooms/:id/disappear', to: "chat_room_users#disappear"
    post 'chat_rooms/:id/typing', to: 'chat_room_users#typing'
    delete 'chat_rooms/:id/finished-typing', to: 'chat_room_users#not_typing'

    get 'posts/:post_id/likes/users', to: 'likes#index'
    get 'rolls/:roll_id/likes/users', to: 'likes#index'
    get 'comments/:comment_id/likes/users', to: 'likes#index'
    get 'users/:user_id/posts', to: 'users#posts'
    get 'users/:user_id/liked-posts', to: 'users#liked_posts'
    get 'users/:user_id/rolls', to: 'users#rolls'
    get 'users/:user_id/liked-rolls', to: 'users#liked_rolls'
    put 'user/update', to: 'users#update'
    get 'posts/:post_id/bookmarks', to: "bookmarks#bookmarked_posts"
    get 'rolls/:roll_id/bookmarks', to: "bookmarks#bookmarked_rolls"
    get 'posts/:post_id/bookmarks/users', to: "bookmarks#bookmarked_users"
    get 'rolls/:roll_id/bookmarks/users', to: "bookmarks#bookmarked_users"
    delete 'posts/:post_id/bookmarks', to: "bookmarks#destroy"
    delete 'rolls/:roll_id/bookmarks', to: "bookmarks#destroy"    
    resources :views, only: [:create, :index]
    resources :activities, only: [:index]
    get 'posts/:post_id/shares/users', to: "shares#users"
    get 'rolls/:roll_id/shares/users', to: "shares#users"
    post 'follow/:user_id', to: 'relationships#follow'
    delete 'unfollow/:user_id', to: 'relationships#unfollow'
    delete 'block/:user_id', to: 'relationships#block'
    post 'unblock/:user_id', to: 'relationships#unblock'
    get  'blocked-users', to: 'relationships#blocked_users'
    get ':user_id/followers', to: 'relationships#followers'
    get ':user_id/following', to: 'relationships#following'
    get 'activities', to: 'activities#index'
    get 'search-chats', to: "search_chat_rooms#search"
    resource :device, only: [:create] 
    get 'followers/:user_id', to: 'relationships#followers'
    get 'following/:user_id', to: 'relationships#following'
    delete 'unlike', to: 'likes#destroy'
    post 'signup', to: "signup#new"
    post 'signup/email', to: "signup#validate_email"
    post 'signup/username', to: "signup#validate_username"
    post 'login', to: 'login#new'
    get ':username', to: 'users#show', constraints: {username: /[0-9a-z_.]{1,60}/}
  end
  

  #the follow/unfollow endpoints
  delete 'block', to: 'users#block'
  post 'follow/:username', to: "relationships#create", constraints: {username: /[0-9a-z_.]{1,60}/}
  delete 'unfollow/:username', to: "relationships#destroy", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'following/:username', to: "users#following", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'followers/:username', to: "users#followers", constraints: {username: /[0-9a-z_.]{1,60}/}
  get 'trending', to: "trending#trending"
  post 'search', to: "search#search"
  post 'search-posts', to: 'search#search_posts'
  post 'search-accounts', to: 'search#search_accounts'
  post 'search-followers/:username', to: 'search#search_followers'
  post 'search-followed-users/:username', to: 'search#search_followed_users'
  post 'search-chat-room-users', to: 'search#search_chat_room_users'
  post 'search-chat-rooms', to: 'search#search_chat_rooms'
  post 'search-topics', to: 'search#search_topics'
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
