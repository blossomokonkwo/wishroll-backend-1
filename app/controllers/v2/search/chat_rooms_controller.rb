class V2::Search::ChatRoomsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @topics = Topic.where("title ILIKE ?", "#{params[:title]}%").order(hot_topic: :desc, media_url: :desc, updated_at: :desc)
        @chat_rooms = ChatRoom.where("name ILIKE ?", "#{params[:name]}%").order(num_users: :desc, updated_at: :desc)
        if @topics.any? or @chat_rooms.any?
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
end
