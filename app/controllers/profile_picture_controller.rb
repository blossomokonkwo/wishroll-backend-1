class ProfilePictureController < ApplicationController
    before_action :authorize_by_access_header!
    def update
        current_user.profile_image.attach require_image_file
        render status: :ok
    end
    def destroy
        current_user.profile_image.purge_later if current_user.profile_image.attached?
        render status: :ok
    end

    private def require_image_file
        params.permit :profile_image
    end
end
