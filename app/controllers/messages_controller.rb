class MessagesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @message = Message.create(body: params[:body], sender_id: current_user.id, chat_room_id: params[:chat_room_id], kind: params[:kind])
         if params[:media_item]
            @message.media_item.attach(params[:media_item])
            @message.media_url = url_for(@message.media_item)
         end
        if @message.save
            MessageRelayJob.perform_later(@message)
            render json: nil, status: 201
        else
            render json: {error: "The message couldn't be created"}, status: 400
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
