class TagsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @tag = Tag.new(tag_params)
        if @tag.save            
            render status: :ok
        else
            render json: nil, status: 400
        end
    end
    #removes and deletes a tag from a post
    def destroy
        @tag = Tag.find(params[:id])
        if @tag.destroy
         response["Success"] = "The tag was successfully deleted"   
         render json: nil, status: :ok
        else
           render json: {error: @tag.error.messages}, status: 400
        end
    end

    def tag_params
        params.permit :text, :post_id
    end

end
