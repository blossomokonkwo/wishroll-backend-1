class V2::ChatRoomsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
      limit = 10
      offset = params[:offset]
      @chat_rooms = current_user.chat_rooms.order(updated_at: :desc).offset(offset).limit(limit)
      if @chat_rooms.any?
        @current_user = current_user
        render :index, status: :ok
      else
        render json: nil, status: :not_found
      end 
    end



    def create
        begin
            @chat_room = current_user.created_chatrooms.create!
            if @chat_room
                @chat_room.users << current_user
                params[:user_ids].each do |user_id|
                    @chat_room.users << User.fetch(user_id)
                end
                @current_user = current_user
                render :create, status: :created
            else
                render json: nil, status: 500
            end 
        rescue => exception
            render json: nil, status: 500
        end
    end

    def update
        chat_room = ChatRoom.find(params[:id])
        if name = params[:name] and chat_room.update(name: name)
            render json: name, status: :ok
        else
            render json: nil, status: 500
        end
    end
    
end