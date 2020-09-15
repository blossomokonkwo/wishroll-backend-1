class V3::RollsController < ApplicationController
    before_action :authorize_by_access_header!

    def create
        begin
            @roll = current_user.rolls.create!(caption: params[:caption])
            @roll.media_item.attach(params[:media_item])
            @roll.thumbnail_image.attach(params[:thumbnail_image])
            @roll.media_url = url_for(@roll.media_item) if @roll.media_item.attached?
            @roll.thumbnail_url = url_for(@roll.thumbnail_image) if @roll.thumbnail_image.attached?
            if @roll.save
              render json: {roll_id: @roll.id}, status: :created          
            else
              render json: {error: "An error occured when creating the roll"}, status: 400         
            end
        rescue => exception
            render json: {error: exception}, status: 400
        end
    end
    

    def index
        if @user = User.fetch(params[:user_id])
            @rolls = @user.created_rolls(offset: params[:offset] || 0, limit: 3).to_a
            if @rolls.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else 
            render json: {error: "User not found with id #{params[:user_id]}"}, status: 400
        end
    end
    
end