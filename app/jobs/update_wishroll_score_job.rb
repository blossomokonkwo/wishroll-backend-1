class UpdateWishrollScoreJob < ApplicationJob
    def perform(user_id, points)
        user = User.find(user_id)
        user.wishroll_score += points
        user.save
    end
    
end