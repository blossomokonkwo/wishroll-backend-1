class TagsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @tag = Tag.new(tag_params)
        if @tag.save            
            render status: :ok
        else
            response["Failure"] = "Unable to save the tag"
            render status: :bad
        end
    end
    #removes and deletes a tag from a post
    def destroy
        @tag = Tag.find(params[:tag_id])
        if @tag.destroy
         response["Success"] = "The tag was successfully deleted"   
         render status: :ok
        else
           render json: {error: @tag.error.messages}, status: :bad
        end
    end

    def tag_params
        params.permit :text, :post_id
    end

end
