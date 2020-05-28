class CreatePostThumbnailJob < ActiveJob
    def perform(post_id, host)
        post = Post.find(post_id)
        post.media_item.open do |file|
            movie = FFMPEG::Movie.new(file.path)
            thumbnail_gif_filename = "thumbnail.gif"
            thumbnail_gif = movie.transcode(thumbnail_gif_filename, %w(-ss 1.0 -t 10 thumbnail.gif))
            post.thumbnail_item.attach(io: File.open(thumbnail_gif.path), filename: SecureRandom.uuid + thumbnail_gif_filename)
            post.thumbnail_url = host + Rails.application.routes.url_helpers.rails_blob_path(roll.thumbnail_gif, only_path: true)
            post.save
        end
    end
    
end