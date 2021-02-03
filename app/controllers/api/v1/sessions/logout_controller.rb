class Api::V1::Sessions::LogoutController < APIController
    before_action :authorize_by_access_header!
    
    def destroy
        # destroy the refresh and access tokens from the redis db
        current_user.devices.where(platform: params[:platform]).destroy_all if params[:platform] #remove all of the users device for the specified platform
        session = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: claimless_payload)
        session.flush_by_access_payload
        render json: {success: "Logged out"}, status: :ok
    end


end