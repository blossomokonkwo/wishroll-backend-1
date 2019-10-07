Rails.application.routes.draw do
  delete 'logout', to: "logout#destroy" #the logout route
  post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
  post 'login', to: "login#create" #the login route
  post 'signup', to: "signup#new" #the signup route 
  post 'profile/edit', to: "profile_picture#update"
  delete 'profile/edit', to: "profile_picture#destroy"
end
