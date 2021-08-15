class MutualRelationshipActivityJob < ApplicationJob
    def perform(mutual_relationship_id:, mutual_id:, user_id:)
        activity_type = "MutualRelationship"
        unless Activity.find_by(active_user_id: mutual_id, user_id: user_id, activity_type: activity_type)
            if mutual_user = User.fetch(mutual_id) and user = User.fetch(user_id) 
                activity_phrase = "You and #{mutual_user.username} are now mutuals!"
                Activity.create(content_id: mutual_relationship_id, active_user_id: mutual_id, user_id: user_id, activity_type: activity_type, activity_phrase: activity_phrase)
            end
        end
    end
    
end