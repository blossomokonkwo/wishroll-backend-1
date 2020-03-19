class SearchChatRoomsAndTopicsController < ApplicationController
    def search
        @topics = Topic("title ILIKE ?", "#{search_params[:title]}%").order(hot_topic: :desc, media_url: :desc, updated_at: :desc)
        @chat_rooms = ChatRoom("name ILIKE ?", "#{search_params[:name]}%").order(num_users: :desc, updated_at: :desc)
        if @topics.any? or @chat_rooms.any?
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
end
