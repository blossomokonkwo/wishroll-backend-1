class LikeActivityJob < ApplicationJob
    def perform(like_id:)
        if like = Like.find(like_id)
            active_user = like.user
            content = like.likeable
            user = content.user
            activity_type = content.class.name
            unless Activity.find_by(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type) or active_user.id == user.id
                can_create_activity = false
                case activity_type
                when "Comment"
                    phrase_suffix = content.original_comment_id ? "your reply 💕" : "your comment 💕"
                when "Post"
                    phrase_suffix = "your post 💕"
                    media_url = content.thumbnail_url || content.media_url
                when "Roll"
                    phrase_suffix = "your roll"
                    media_url = content.thumbnail_url 
                end
                likes_count = content.likes_count
                if likes_count < 11
                    phrase = "#{active_user.username} liked #{phrase_suffix}"
                    can_create_activity = true
                else
                    if likes_count < 101
                        step_value = 10
                        start_value = 11
                        end_value = 101
                    elsif likes_count < 1001
                        step_value = 100
                        start_value = 101
                        end_value = 1001
                    elsif likes_count < 10001
                        step_value = 1000
                        start_value = 1001
                        end_value = 10001
                    elsif likes_count < 100_001
                        step_value = 10_000
                        start_value = 10_001
                        end_value = 100_001
                    elsif likes_count < 1_000_000
                        step_value = 100_000
                        start_value = 100_001
                        end_value = 1_000_000
                    end
                    (start_value..end_value).step(step_value) do |num|
                        if likes_count == num
                            phrase = "#{active_user.username} liked #{phrase_suffix}\nOver #{likes_count.pred.to_s(:delimited)} people have liked #{phrase_suffix}"
                            can_create_activity = true
                            break
                        end
                    end
                end
                Activity.create(content_id: content.id, user_id: user.id, active_user_id: active_user.id, activity_type: activity_type, media_url: media_url, activity_phrase: phrase) if can_create_activity
            end
        end
    end
    
end