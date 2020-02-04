json.array! @comments.each do |comment|
    cache comment, expires_in: 5.minutes do
        json.(comment, :id, :original_comment_id, :user_id, :post_id, :body, :replies_count, :likes_count, :created_at, :updated_at)
    end
end
