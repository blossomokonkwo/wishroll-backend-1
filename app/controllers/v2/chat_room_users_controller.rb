class V2::ChatRoomUsersController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 12
        offset = params[:offset]
        @users = ChatRoom.find(params[:chat_room_id]).users.order("chat_room_users.created_at DESC").offset(offset).limit(limit)
        if @users.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def destroy
        chat_room_user = ChatRoomUser.find_by(chat_room_id: params[:chat_room_id], user_id: current_user.id)
        if chat_room_user.destroy
            render json: nil, status: :ok
        else
            render json: nil, status: :bad_request
        end
    end
    
    
end