class TagsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @tag = Tag.create(tag_params)
        if @tag.save            
            render text: "The tag was saved", status: :ok
        else
            render text: "The tag was not saved", status: :bad
        end
    end

    # def index
    #     @posts = .all
    # end
    
    

    #removes and deletes a tag from a post
    def destroy
        @tag = Tag.find(params[:tag_id])
        if @tag.destroy
         render text: "Your tag has been destroyed", status: :ok
        else
           render json: {error: @tag.error.messages}, status: :bad
        end
    end

    def tag_params
        params.permit :text, :post_id
    end

end
