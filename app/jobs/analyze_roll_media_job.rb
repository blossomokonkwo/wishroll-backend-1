class AnalyzeRollMediaJob < ApplicationJob
    require 'streamio-ffmpeg'
    require 'securerandom'
    def perform(roll_id, host)
        roll = Roll.find(roll_id)
        roll.media_item.open do |file|
            movie = FFMPEG::Movie.new(file.path)
            #thumbnail generation
            filename = "roll_thumbnail.jpg"
            thumbnail = movie.screenshot(filename, seek_time: movie.duration / 2, quality: 5.0, preserve_aspect_ratio: :width)
            roll.thumbnail_image.attach(io: File.open(thumbnail.path), filename: SecureRandom.uuid + filename)
            roll.thumbnail_url = host + Rails.application.routes.url_helpers.rails_blob_path(roll.thumbnail_image, only_path: true)
            roll.content_type = roll.media_item.blob.content_type
            roll.save
            CreateRollThumbnailGifJob.perform_now(roll_id, host)
        end
    end
    
end