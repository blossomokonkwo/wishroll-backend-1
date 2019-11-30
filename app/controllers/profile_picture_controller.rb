class ProfilePictureController < ApplicationController
    before_action :authorize_by_access_header!
    def update
        current_user.profile_image.attach(params[:image_file])
    end
    def destroy
        current_user.profile_image.purge_later if current_user.profile_image.attached?
        render status: :ok
    end
end
