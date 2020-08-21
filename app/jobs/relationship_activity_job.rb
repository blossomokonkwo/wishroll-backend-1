class RelationshipActivityJob < ApplicationJob
    def perform(follower_user_id:, followed_user_id:, relationship_id:)
        activity_type = "Relationship"
        unless Activity.find_by(active_user_id: follower_user_id, user_id: followed_user_id, activity_type: activity_type)
            if followed_user = User.find(followed_user_id) and follower_user = User.find(follower_user_id)
                can_create_activity = false
                activity_phrase_prefix = "#{follower_user.username} began following you"
                followers_count = followed_user.followers_count
                if followers_count < 101
                    activity_phrase = activity_phrase_prefix
                    can_create_activity = true
                else
                    if followers_count < 1001
                        start_value = 101
                        end_value = 1001
                        step_value = 100
                    elsif followers_count < 10_001
                        start_value = 1001
                        end_value = 10_001
                        step_value = 500
                    elsif followers_count < 100_001
                        start_value = 10_001
                        end_value = 100_001
                        step_value = 1_000
                    elsif followers_count < 1_000_001
                        start_value = 100_001
                        end_value = 1_000_001
                        step_value = 100_000
                    end
                    (start_value..end_value).step(step_value) do |num| 
                        if followers_count == num
                            activity_phrase = "#{activity_phrase_prefix}\nYou now have over #{followers_count.pred.to_s(:delimited) } followers"
                            can_create_activity = true
                            break
                        end
                    end
                end
                Activity.create(content_id: relationship_id, active_user: follower_user, user: followed_user, activity_type: activity_type, activity_phrase: activity_phrase) if can_create_activity
            end
        end
    end
    
end