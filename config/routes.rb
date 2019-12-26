Rails.application.routes.draw do
  resource :user, except: [:create, :indexç] do
    resources :posts, except: [:update], param: :post_id
    resources :tags, only: [:create, :destroy], param: :tag_id
  end
  get 'feed', to: "feed#feed"
  post 'search', to: "search#search"
  get 'posts/:id', to: "posts#show"
  delete 'logout', to: "logout#destroy" #the logout route
  post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
  post 'login', to: "login#create" #the login route
  post 'signup', to: "signup#new" #the signup route 
end
