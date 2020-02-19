class UpdateProfileUrlJob < ApplicationJob
  queue_as :default

  def perform(current_user)
    current_user.profile_picture_url = url_for(current_user.profile_picture) if current_user.profile_picture.attached?
    current_user.save
  end
end
