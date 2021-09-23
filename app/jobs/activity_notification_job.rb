class ActivityNotificationJob < ApplicationJob  
    queue_as :notifications
    def perform(activity_id)
        activity = Activity.find(activity_id)
        if activity
            user = User.find(activity.user_id)
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            if user.current_device
                n.device_token = user.current_device.device_token
                n.alert = {title: "#{activity.activity_phrase}"}
                n.mutable_content = true
                if activity.activity_type == "Comment"
                    comment = Comment.find(activity.content_id)
                    n.alert = {title: "#{activity.activity_phrase}", body: comment.body}
                    if post = comment.post
                        activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, updated_at: activity.updated_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}, comment: {id: comment.id, original_comment_id: comment.original_comment_id, created_at: comment.created_at, updated_at: comment.updated_at, like_count: comment.likes_count, body: comment.body, reply_count: comment.replies_count, user: {id: comment.user.id, username: comment.user.username, name: comment.user.name, verified: comment.user.verified, avatar: comment.user.avatar_url}}, post: {id: post.id, created_at: post.created_at, updated_at: post.updated_at, user: {id: post.user.id, username: post.user.username, verified: post.user.verified}}}
                    elsif roll = comment.roll
                        activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}, roll: {id: roll.id, uuid: roll.uuid, media_url: roll.media_url, thumbnail_url: roll.thumbnail_url, like_count: roll.likes_count, caption: roll.caption, view_count: roll.view_count, created_at: roll.created_at, updated_at: roll.updated_at, comment_count: roll.comments_count, share_count: roll.share_count, viewed: true, liked: false, bookmarked: false, bookmark_count: roll.bookmark_count, user: {id: roll.user.id, username: roll.user.username, verified: roll.user.verified}}}
                    end
                elsif activity.activity_type == "Post"
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}, post: {id: activity.post.id, media_url: activity.post.media_url, thumbnail_url: activity.post.thumbnail_url, caption: activity.post.caption, created_at: activity.post.created_at, updated_at: activity.post.updated_at, user: {id: activity.post.user.id, username: activity.post.user.username, verified: activity.post.user.verified}}}
                elsif activity.activity_type == "Relationship"
                    n.alert = {title: "#{activity.activity_phrase}", body: "Check out their profile!"}
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}}
                elsif activity.activity_type == "MutualRelationshipRequest"
                    n.alert = {title: "#{activity.activity_phrase}", body: "Check out their profile!"}
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, action_items: [{title: "Accept", url: "https://www.wishroll.co/v1/mutuals/mutual_relationship_requests/accept", type: "button", style: "default"}, {title: "Deny", url: "https://www.wishroll.co/v1/mutuals/mutual_relationship_requests/deny", type: "button", style: "destructive"}], active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}}
                elsif activity.activity_type == "MutualRelationship"
                    n.alert = {title: "#{activity.activity_phrase}", body: "Check out their profile!"}              
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, name: activity.active_user.name, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}}
                end                
                n.data = {activity: activity_hash}
                n.sound = "activity_notification_sound.caf"
                n.badge = Message.num_unread_messages(activity.user)
                n.save!
            end
        end        
    end
end