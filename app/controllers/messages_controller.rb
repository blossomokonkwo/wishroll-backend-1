class MessagesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @message = Message.new body: params[:body], sender_id: current_user.id, chat_room_id: params[:chat_room_id]
         if params[:media_item]
            @message.media_item.attach(params[:media_item])
            @message.media_url = url_for(@message.media_item)
         end
        if @message.save
            MessageRelayJob.perform_later(@message)
        end
    end
    
    def update
        @message = Message.find(params[:message_id])
        if @message.update(params[:body])
            render json: nil, status: 200
        else
            render json: {error: "Could not update message"}, status: 400
        end
    end

    def destroy
        @message = Message.find(params[:message_id])
        if @message.destroy
            render json: nil, status: :ok
        else
            render json: {error: "Could not delete this message"}, status: 400
        end
    end
    
end