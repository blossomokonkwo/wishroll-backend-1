class CaptionExtractionJob < ApplicationJob
    def perform(roll_id)
        roll = Roll.fetch(roll_id)
        roll.extract_hashtags do |hashtag|
            roll.hashtags.create!(text: hashtag, user: roll.user)
        end
        roll.extract_mentions do |mention|
            if mentioned_user = User.fetch_by_username(mention)
                roll.mentions.create!(mentioned_user: mentioned_user, user: roll.user) if mentioned_user != roll.user
            end
        end
    end
    
end