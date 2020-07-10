class V2::DevicesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #if the device ha already been created then that indicates that the user already has a registered device with their account
        @device = current_user.devices.find_by(device_token: params[:device_token], platform: params[:platform])
        old_current_device = current_user.current_device    
        if @device           
            if old_current_device and old_current_device != @device
                old_current_device.current_device = false
                old_current_device.save
                @device.current_device = true
                @device.save
            end 
            render json: {error: "This device has already been created"}, status: 500
        else
            if old_current_device
                old_current_device.current_device = false
                old_current_device.save
            end
            @device = current_user.devices.create!(device_token: params[:device_token], platform: params[:platform], current_device: true)
            render json: nil, status: :created
        end
    end
        
end
