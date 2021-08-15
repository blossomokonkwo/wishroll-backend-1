class MutualRelationshipRequestActivityJob < ApplicationJob
    def perform(mutual_request_id:, requested_user_id:, requesting_user_id:)
        activity_type = "MutualRelationshipRequest"
        unless Activity.find_by(active_user_id: requesting_user_id, user_id: requested_user_id, activity_type: activity_type)
            if requested_user = User.fetch(requested_user_id) and requesting_user = User.fetch(requesting_user_id)
                activity_phrase = "#{requesting_user.username} wants to be mutuals!"
                Activity.create(content_id: mutual_request_id, active_user_id: requesting_user_id, user_id: requested_user_id, activity_type: activity_type, activity_phrase: activity_phrase)
            end
            
        end
    end
    
    
end