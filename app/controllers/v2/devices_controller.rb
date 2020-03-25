class V2::DevicesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #first search for a device based on the unique device token
        @device = current_user.create_device(device_token: params[:device_token], platform: params["platform"])
        if @device
        render json: nil, status: 201
        else
            render text: "This device has already been created", status: 500
        end
    end
        
end
