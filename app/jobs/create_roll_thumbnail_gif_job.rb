class CreateRollThumbnailGifJob < ApplicationJob
    def perform(roll_id, host)
        roll = Roll.find(roll_id)
        roll.media_item.open do |file|
        movie = FFMPEG::Movie.new(file.path)
            thumbnail_gif_filename = "thumbnail.gif"
            thumbnail_gif = movie.transcode(thumbnail_gif_filename, %w(-ss 1.0 -t 10 thumbnail.gif))
            roll.thumbnail_gif.attach(io: File.open(thumbnail_gif.path), filename: SecureRandom.uuid + thumbnail_gif_filename)
            roll.thumbnail_gif_url = host + Rails.application.routes.url_helpers.rails_blob_path(roll.thumbnail_gif, only_path: true)
            roll.save
        end
    end
    
end