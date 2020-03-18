class TopicsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @topic = Topic.new(title: params[:title], hot_topic: params[:hot_topic], user_id: current_user.id, topic_image: params[:topic_image])
        if @topic.save
          render json: nil, status: 201
        else
          render json: {error: "Topic could not be created"}, status: 400
        end
    end

    def index
        @hot_topics = Topic.where(hot_topic: true).includes([:topic_image_attachment])
        @topics = Array.new
        @topics = current_user.topics if current_user.topics.any?
        @chat_rooms = current_user.chat_rooms
        if @chat_rooms.any?
            @chat_rooms.includes(:topic).each do |chat_room|
                if chat_room.topic.present?
                    ActiveRecord::Base.connected_to(role: :writing) do
                    @topics << chat_room.topic if !@topics.include?(chat_room.topic)
                    end
                end
            end
        end
        if @hot_topics.any? or @topics.any?
            render :index, status: 200
        else
            render json: {error: "There are no topics for you"}, status: 404
        end
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
