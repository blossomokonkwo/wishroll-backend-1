class Api::V2::TagsController < APIController
    def create
        if params[:post_id] and @post = Post.find(params[:post_id])
            begin
                params[:tags].each do |text|
                    @post.tags.create!(text: text)
                end
                render json: nil, status: :created
            rescue => exception
                render json: {error: "The tag could not be created for the specified post: #{@post}"}, status: :bad_request
            end
        else
            render json: {error: "Could not find a resource that can create tags"}, status: :bad_request
        end
    end


    def update
        @tag = Tag.find(params[:id])
        if @tag.update_attributes(params[:tag])
            render json: @tag, status: :ok
        else
            render json: {error: "Tag could not be created with the params: #{params[:tag]}"}, status: :bad_request
        end
    end


    def destroy
        if @tag = Tag.find(params[:id]) and @tag.destroy
            render json: nil, status: :ok
        else
            render json: {error: "The specified tag with id #{params[:id]} could not be destroyed"}, status: 500
        end
    end

    def index
        if @tags = Post.fetch(params[:post_id]).tags.to_a
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end