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
                    post = comment.fetch_post
                    n.alert = {title: "#{activity.activity_phrase}", body: comment.body}
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}, post: {id: post.id, uuid: post.uuid, media_url: post.media_url, thumbnail_url: post.thumbnail_url, like_count: post.likes_count, caption: post.caption, view_count: post.view_count, created_at: post.created_at, updated_at: post.updated_at, comment_count: post.comments_count, share_count: post.share_count, viewed: true, liked: false, bookmarked: false, bookmark_count: post.bookmark_count, creator: {id: post.user.id, username: post.user.username, verified: post.user.verified}}}
                elsif activity.activity_type == "Post"
                    post = Post.find(activity.content_id)
                    activity_hash = {id: activity.id, phrase: activity.activity_phrase, created_at: activity.created_at, type: activity.activity_type, active_user: {id: activity.active_user.id, username: activity.active_user.username, avatar: activity.active_user.avatar_url, verified: activity.active_user.verified}, post: {id: post.id, uuid: post.uuid, media_url: post.media_url, thumbnail_url: post.thumbnail_url, like_count: post.likes_count, caption: post.caption, view_count: post.view_count, created_at: post.created_at, updated_at: post.updated_at, comment_count: post.comments_count, share_count: post.share_count, viewed: true, liked: false, bookmarked: false, bookmark_count: post.bookmark_count, creator: {id: post.user.id, username: post.user.username, verified: post.user.verified}}}
                end                
                n.data = {activity: activity_hash}
                n.save!
            end
        end        
    end
end