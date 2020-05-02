class V2::RecommendationController < ApplicationController
    before_action :authorize_by_access_header!
=begin
The #recommend_videos method returns videos that closely relate to the current video being displayed to the user. This method uses attributes like 
tags params to determine what type of videos to recommend to the user next. As the application gets more complex, the recommnedation service will be
a standalone service that will drive the user experience accross the app. Complex machine learning algorithims will be used to ensure that users are only
recommended the content that they are most interested in. This method uses infinite scrolling which means that data is returned incrementally as the user scrolls 
through the page.
=end
    def recommend_videos
        #recommend only videos
        limit = 10
        offset = params[:offset] #how many posts to skip before returning the new data
        @recommended_video_posts = Array.new
        @post = Post.find(params[:post_id]) #the reference post for the recommendations
        @post_user = @post.user #the reference post user
        #loop through the tags of the video in order to derive their associated posts
        Tag.where("text ILIKE ?", "%#{params[:text]}%").order(view_count: :desc, likes_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit).find_each do |tag|
            post = tag.post
            url = post.posts_media_url
            #only add the post to the array if it is in a movie format(mp4, mov)
            @recommended_video_posts << post if !current_user.reported_posts.include?(post) and (url.end_with?("mov") or url.end_with?("mp4")) and (post.id != @post.id)
        end
        if @recommended_video_posts.any? 
            #sort the recommended posts so that the creator of the reference post has his or her content more prevalant.
            @recommended_video_posts.sort! do |a,b|
                if a.user == @post_user and b.user != @post_user
                    return -1
                elsif b.user == @post_user and a.user != @post_user
                    return 1
                elsif a.user != @post_user and b.user != @post.user
                    return -1
                else
                    return 0
                end
            end
            render :recommend_videos, status: 200
        else
            render json: nil, status: 404
        end
    end

    def recommend_posts
        #recommend videos, photos, and gifs
        limit = 50
        offset = params[:offset]
        @recommend_posts = Array.new
        @post = Post.find(params[:post_id])
        @post_user = @post.user
        Tag.where("text ILIKE ?", "%#{params[:text]}%").order(view_count: :desc, likes_count: :desc, created_at: :desc).offset(offset).limit(limit).find_each do |tag|
            @recommend_posts << tag.post if (post.id != @post.id)
        end
        if @recommend_posts.any?
            @recommend_posts.sort! do |a,b|
                if a.user == @post_user and b.user != @post_user
                    return -1
                elsif b.user == @post_user and a.user != @post_user
                    return 1
                elsif a.user != @post_user and b.user != @post.user
                    return -1
                else
                    return 0
                end
            end
            render :recommend_posts, status: 200
        else
            render json: nil, status: 404
        end
    end

    



end
