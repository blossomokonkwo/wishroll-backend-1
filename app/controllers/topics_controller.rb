class TopicsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @topic = Topic.new(title: params[:title], hot_topic: params[:hot_topic], user_id: current_user.id)
        if params[:topic_image]
            @topic.topic_image.attach params[:topic_image]
            @topic.media_url = url_for(@topic.topic_image)
        end
        if @topic.save
          render json: nil, status: 201
        else
          render json: {error: "Topic could not be created"}, status: 400
        end
    end

    def show
        @topic = Topic.find(params[:topic_id])
        render :show, status: 200
    end

    def index
        @hot_topics = Topic.where(hot_topic: true)
        @chat_rooms = current_user.chat_rooms
        if @chat_rooms.present?
            @chat_rooms.each do |chat_room|
                if chat_room.topic.present?
                    @topics << chat_room.topic
                end
            end
        end
        render :index, status: 404
    end
    
    def destroy 
        @topic = Topic.find(params[:topic_id])
        if current_user == @topic.user
            if @topic.destroy
                render json: nil, status: 200
            else
                render json: {error: "The topic could not be destroyed"}, status: 500
            end
        else
            render json: {error: "You do not have permission to destroy this topic"}, status: 400
        end
    end
    
end
