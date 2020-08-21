class ShareActivityJob < ApplicationJob
    def perform(current_user_id:, share_id:)
        if share = Share.find(share_id)
            shareable = share.shareable
            user = shareable.user
            activity_type = shareable.class.name
            unless Activity.find_by(content_id: shareable.id, active_user_id: current_user_id, user_id: user.id, activity_type: activity_type) or user.id == current_user_id                
                active_user = User.find(current_user_id)
                case activity_type 
                when "Post"
                    phrase_suffix = "your post"
                when "Roll"
                    phrase_suffix = "your roll"
                end
                share_count = shareable.share_count
                can_create_activity = false
                if share_count < 11
                    activity_phrase = "#{active_user.username} shared #{phrase_suffix}"
                    can_create_activity = true
                else
                    if share_count < 101
                        step_value = 10
                        start_value = 11
                        end_value = 101
                    elsif share_count < 1001
                        step_value = 100
                        start_value = 101
                        end_value = 1001
                    elsif share_count < 10001
                        step_value = 1000
                        start_value = 1001
                        end_value = 10001
                    elsif share_count < 100_001
                        step_value = 10_000
                        start_value = 10_001
                        end_value = 100_001
                    elsif share_count < 1_000_000
                        step_value = 100_000
                        start_value = 100_001
                        end_value = 1_000_000
                    end
                    (start_value..end_value).step(step_value) do |num| 
                        if share_count == num
                            activity_phrase = "#{active_user.username} shared #{phrase_suffix}\nOver #{share_count.pred.to_s(:delimited)} people have shared #{phrase_suffix}"
                            can_create_activity = true
                            break
                        end
                    end
                end
                Activity.create(content_id: shareable.id, active_user_id: current_user_id, user_id: user.id, activity_type: activity_type, media_url: shareable.thumbnail_url || shareable.media_url, activity_phrase: activity_phrase) if can_create_activity
            end
        end
    end
    
end