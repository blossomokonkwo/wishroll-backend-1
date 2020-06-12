class CreatePostThumbnailJob < ApplicationJob
    def perform(post_id, host)
        post = Post.find(post_id)
        post.media_item.open do |file|
            movie = FFMPEG::Movie.new(file.path)
            #thumbnail generation
            filename = "post_thumbnail.jpg"
            thumbnail = movie.screenshot(filename, seek_time: movie.duration / 2, quality: 5.0, preserve_aspect_ratio: :width)
            post.thumbnail_item.attach(io: File.open(thumbnail.path), filename: SecureRandom.uuid + filename)
            post.thumbnail_url = host + Rails.application.routes.url_helpers.rails_blob_path(post.thumbnail_item, only_path: true)
            post.content_type = post.media_item.blob.content_type
            post.save
        end
        post.save
    end
    
end