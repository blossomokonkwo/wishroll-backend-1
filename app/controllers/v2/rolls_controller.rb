class V2::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        begin            
            @roll = Roll.new(caption: params[:caption], user_id: current_user.id) 
            @roll.media.attach params[:media]
            #@roll.media.attach params[:thumbnail] 
            @roll.media_url = url_for(@roll.media)
            #@roll.thumbnail_url = url_for(@roll.thumbnail)         
            if @roll.save
                render json: nil, status: :created
            else
                render json: {error: "Could not create media and thumbnail urls for the specified post"}, status: 500
            end
        rescue => exception
            render json: {error: "Roll could not be created"}, status: :bad_request
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