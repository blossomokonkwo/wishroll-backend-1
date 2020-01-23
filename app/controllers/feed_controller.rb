class FeedController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        #this method retrieves all of the posts created by all of the followers that the current user follows ordered by most recent creation date
        if current_user.followed_users.count > 0
            @posts = Array.new
            current_user.followed_users.each do |followed_user|
                #it wouldn't make sense to return all the posts created by the current_users followed users 
                #it wouldn't make sense because it would be way too much load on the server and the latency would be to high
                #intuitively, most users only want to see the most recent posts made by the users that they follow. This app can expect up to 
                #hundreds of posts weekly by any given user. If user A follows 1000 users and each of those users posts a thousand posts by the end of the week,
                #then at the end of the week, the current_user won't even be able to load his or her feed page in under 3 seconds
                followed_user.posts.each do |post|
                    #we check if each post is newer than 3 days old.
                    #most social media users will only view the most recent posts.
                   if (DateTime.current - 3.days) < post.created_at
                    @posts << post
                   end
                end
            end
            if @posts.count > 0 
                render :index, status: :ok
            else
                render json: {error: "There are no posts in your feed"}, status: 404
            end
        else
            render json: {error: "You are not following anyone"}, status: 404
        end
        
    end
end
