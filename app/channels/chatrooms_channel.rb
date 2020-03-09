class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
