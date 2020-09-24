class CommentActivityJob < ApplicationJob
    def perform(comment_id, active_user_id)
        if comment = Comment.find(comment_id)
            if active_user = User.fetch(active_user_id)
                if commentable = comment.roll || comment.post
                    if original_comment_id = comment.original_comment_id
                        original_comment = Comment.find(original_comment_id)
                        if user_id = original_comment.user.id and user_id != active_user.id                        
                            activity_phrase = "#{active_user.username} replied to your comment"
                        else
                            #return if the active user is replying to a comment that they created
                            return
                        end
                    else
                        if user_id = commentable.user.id and user_id != active_user.id                            
                            activity_phrase = "#{active_user.username} commented on your #{commentable.class.name.downcase!}"
                        else
                            #return out of the function if a user is commenting on their own post 
                            return
                        end
                    end
                    Activity.create(user_id: user_id, active_user_id: active_user.id, activity_phrase: activity_phrase, activity_type: comment.class.name, content_id: comment.id, media_url: commentable.thumbnail_url || commentable.media_url)
                end
            end
        end
    end
    
end