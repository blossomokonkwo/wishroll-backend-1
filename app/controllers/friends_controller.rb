class FriendsController < ApplicationController
    before_action :authorize_by_access_header!
    def add
        friend = User.find_by(username: params[:friend_username])
        current_user.friends << friend if friend
    end
    
    def all
        friends = Array.new
        for f in current_user.friends
            friend = {} 
            friend["username"] = f.username
            friend["first_name"] = f.first_name
            friend["last_name"] = f.last_name
            friend["bio"] = f.last_name
            friends << friend
        end
        render json: {friends: friends}, status: :ok
    end

    def delete
        friend = User.find_by(username: params[:friend_username])
        current_user.friends.destroy(friend)
        render plaintext: "You successfully unfriended #{friend.username}",  status: :ok 
    end

end
