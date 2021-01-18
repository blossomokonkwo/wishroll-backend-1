root to: "feed#index"
get 'privacy', to: "privacy_policy#privacy"
get 'terms', to: "terms#terms"
get 'contact', to: "support#contact"
get 'home', to: "home#homepage"
get 'what-is-wishroll', to: "home#whatis"


delete 'logout', to: "logout#destroy" #the logout route
post 'refresh', to: "refresh#create" #the refresh controller where refresh tokens are returned
post 'login', to: "login#create" #the login 


# registration flow
post 'signup/email', to: "signup#validate_email" #this route validates that a user enters an appropriate email that is unique
post 'signup/username', to: "signup#validate_username" #this route validates a users username for uniqueness and that it matches the regex
post 'signup', to: "signup#new" #the signup route. This route allows a user to sign up for the service 

# path to users show action using the username key
get ':username', to: "users#show", constraints: {username: /[0-9a-z_.]{1,60}/}