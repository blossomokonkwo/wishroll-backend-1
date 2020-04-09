class V2::DevicesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #first search for a device based on the unique device token
        @device = Device.create!(device_token: params[:device_token], platform: params["platform"], user_id: current_user.id)
        #if the device ha already been created then that indicates that the user already has a registered device with their account
        if @device
        render json: nil, status: 201
        else
            #if the device token isn't unique, we want to set the current users current device to the most recent device token that is sent through the params hash
            current_user.current_device = Device.where(device_token: params[:device_token]).first
            render text: "This device has already been created", status: 500
        end
    end
        
end
