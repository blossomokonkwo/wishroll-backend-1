class V2::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        begin            
            @roll = Roll.create!(caption: params[:caption], user_id: current_user.id, original_roll_id: params[:original_roll_id]) 
            @roll.media_item.attach params[:media_item] if params[:media_item]
            @roll.thumbnail_image.attach params[:thumbnail_image] if params[:thumbnail_image]
            @roll.media_url = url_for(@roll.media_item) if @roll.media_item.attached?
             @roll.thumbnail_url = url_for(@roll.thumbnail_image) if @roll.thumbnail_image.attached?  
            if @roll.save
                CreateLocationJob.perform_later(params[:ip_address], params[:timezone], @roll.id, @roll.class.name)
                render json: {roll_id: @roll.id}, status: :created
            else
                render json: {error: "Could not create media and thumbnail urls for the specified post"}, status: 500
            end
        rescue => exception
            render json: {error: "Roll could not be created #{@roll.errors.inspect}"}, status: :bad_request
        end
    end
    
    def show
        @roll = Roll.find(params[:id])
        @reactions = @roll.reactions
        if @roll
            render :show, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    def update
        @roll = Roll.find(params[:id])
        if @roll.update_attributes(update_params)
            render json: nil, status: :ok
        else
            render json: {error: "Roll - #{@roll} couldn't be updated"}, status: :bad_request
        end
    end

    def destroy
        @roll = Roll.find(params[:id])
        if @roll.destroy
            render json: nil, status: :ok
        else
            render json: {error: "Couldn't destroy post - #{@roll}"}, status: 500
        end
    end

    private 
    def create_params
        params.permit :media_item, :caption, :original_roll_id 
    end

    def update_params
        params.permit :caption
    end
end