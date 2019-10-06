class RefreshController < ApplicationController
  before_action :authorize_refresh_by_access_request!
  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload
    render json: {access: tokens[:access], csrf: tokens[:csrf], access_expires_at: tokens[:access_expires_at]}, status: :ok
  end
end
