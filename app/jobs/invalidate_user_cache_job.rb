class InvalidateUserCacheJob < ApplicationJob
    def perform(user_id)
        user = User.find(user_id)
        Rails.cache.delete("Current user is: #{user_id}")
        user.posts.each do |post|
            Rails.cache.delete("Post: #{post.id} belongs to a user")
        end
    end
    
end