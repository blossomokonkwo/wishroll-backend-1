class ImageController < ApplicationController
    def image_size
        begin
            size = Rails.cache.fetch(params[:image_uri]){
                uri = "https://www.wishroll.co/rails/active_storage/blobs/#{params[:image_uri]}"
                FastImage.size(uri, raise_on_failure: true)
            }
            render json: {width: size[0], height: size[1]}, status: 200
        rescue => exception
            render json: {error: exception}, status: 500
        end
    end
    
end
