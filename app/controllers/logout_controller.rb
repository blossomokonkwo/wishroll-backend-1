class LogoutController < ApplicationController
  before_action :authorize_by_access_header!
  def destroy
    #destroy the refresh and access tokens from the redis db
    #claimless_payload : "the payload that is read from the header (the access payload)"
    #refresh_by_access_payload : "the refresh payload isn;t stored on the client side and isn't used for authorization"
    current_user.devices.where(platform: params[:platform]).destroy_all if params[:platform] #remove all of the users device for the specified platform
    session = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: claimless_payload)
    session.flush_by_access_payload
    render json: {success: "You have been successfully logged out"}, status: :ok
  end
end
