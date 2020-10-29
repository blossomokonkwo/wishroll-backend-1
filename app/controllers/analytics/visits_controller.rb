class Analytics::VisitsController < ActionController::API

    def create
        @visit = Visit.new(app_version: params[:app_version], os_version: params[:os_version], platform: params[:platform], device_type: params[:device_type], os: params[:os], user_agent: request.user_agent, ip: request.remote_ip, user_id: params[:user_id], visitor_token: params[:visitor_token], visit_token: params[:visit_token])
        if @visit.save
          render json: nil, status: :ok
        else
            render json: nil, status: :bad_request
        end
    end
    
    
end