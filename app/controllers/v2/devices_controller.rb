class V2::DevicesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #if the device ha already been created then that indicates that the user already has a registered device with their account
        @device = current_user.devices.where(device_token: params[:device_token], platform: params["platform"]).first
        if @device
            old_current_device = current_user.current_device    #devices.where(current_device: true).first.current_device
            if !old_current_device or old_current_device.device_token != @device.device_token
                @device.current_device = true
                @device.save
            end
            render json: {error: "This device has already been created"}, status: 500
        else
            @device = current_user.devices.create!(device_token: params[:device_token], platform: params[:platform], current_device: true)
            render json: nil, status: :created
        end
    end
        
end
