# Scope all api routes under the api namespace without requiring 'api' in the url
scope module: :api do
    # all routes inteded for the WishRoll API must use the 'api' subdomain and have an Accept header of JSON
    constraints subdomain: Rails.env.eql?('production') ? 'api' : '', format: 'json' do
      namespace :v3 do

        namespace :feed do
          resources :posts, only: [:index]
        end

        namespace :trending do
          resources :trending_tags, only: [:index, :show]
          resources :posts, only: [:index]
        end

        namespace :discover do
          resources :rolls, only: [:index]
        end

        namespace :privacy do 
          resources :reported_posts, only: [:create]
        end
        namespace :search do
          resources :posts, :users, :rolls, only: [:index]
        end

        namespace :recommendation do
          resources :posts, :rolls, :users, only: [:index]
        end

        namespace :keyboard do 
          namespace :trending do
            resources :posts, only: [:index]
          end

          namespace :bookmarks do
            resources :posts, only: [:index]
          end

          namespace :liked do
            resources :posts, only: [:index]
          end

          namespace :recommendation do
            resources :posts, only: [:index]
          end

          namespace :uploaded do
            resources :posts, only: [:index]
          end

          namespace :search do 
            resources :posts, only: [:index]
          end

          resources :shares, only: [:create]
        end

      end
    
      namespace :v2 do

        namespace :search do
        resources :posts, :users, :relationships, :rolls, :chat_rooms, only: [:index]
        end

        namespace :trending do
          resources :posts, :rolls, only: [:index]       
        end

        namespace :feed do
          resources :posts, :rolls, only: [:index]                    
        end

        namespace :recommendation do
          resources :posts, :rolls, only: [:index]
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
        
        resources :users, only: [:update, :show, :destroy] do
          resources :albums, shallow: true
          resources :bookmarks, only: [:index]
        end
    
        resources :chat_rooms, only: [:index, :create, :update] do
          resources :messages, shallow: true
          resources :chat_room_users
        end
    
        resources :announcements, only: [:index, :create, :show]
    
        post 'chat_rooms/:id/appear', to: "chat_room_users#appear"
        delete 'chat_rooms/:id/disappear', to: "chat_room_users#disappear"
        post 'chat_rooms/:id/typing', to: 'chat_room_users#typing'
        delete 'chat_rooms/:id/finished-typing', to: 'chat_room_users#not_typing'
    
        get 'posts/:post_id/likes/users', to: 'likes#index'
        get 'rolls/:roll_id/likes/users', to: 'likes#index'
        get 'comments/:comment_id/likes/users', to: 'likes#index'
        get 'users/:user_id/posts', to: 'users#posts'
        get 'users/:user_id/liked-posts', to: 'users#liked_posts'
        get 'users/current_user/created-posts', to: 'users#current_user_created_posts'
        get 'users/current_user/current-user-liked-posts', to: 'users#current_user_liked_posts'
        get 'users/current_user/bookmarked-posts', to: 'users#current_user_bookmarked_posts'
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
        resource :device, only: [:create] 
        get 'followers/:user_id', to: 'relationships#followers'
        get 'following/:user_id', to: 'relationships#following'
        delete 'unlike', to: 'likes#destroy'
        get ':username', to: 'users#show', constraints: {username: /[0-9a-z_.]{1,60}/}
      end

    namespace :v1 do
      scope module: :sessions do
        post 'login', to: 'login#new'
        delete 'logout', to: 'logout#destroy'
      end

      scope module: :registration do
        post 'signup', to: "signup#new"
        post 'signup/email', to: "signup#validate_email"
        post 'signup/username', to: "signup#validate_username"
      end

      scope module: :accounts do
        post 'reset-password', to: 'forgot_password#reset_password'
      end

    end




    end 
  end