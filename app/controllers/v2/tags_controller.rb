class V2::TagsController < ApplicationController
    def create
      if params[:roll_id] and @roll = Roll.find(params[:roll_id])
            begin
                params[:tags].each do |text|
                    @roll.tags.create!(text: text.delete!(":").delete!(";"))
                end
                render json: nil, status: :created
            rescue => exception
                render json: {error: "The tag could not be created for the specified roll: #{@roll}"}, status: :bad_request
            end
        elsif params[:post_id] and @post = Post.find(params[:post_id])
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
        @tag = Tag.find(params[:id])
        if @tag.destroy
            render json: nil, status: :ok
        else
            render json: {error: "The specified tag with id #{params[:id]} could not be destroyed"}, status: 500
        end
    end

    def index
        if params[:roll_id]
            @roll = Roll.find([:roll_id])
            @tags = @roll.tags.to_a
            if @tags.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:post_id]
            @post = Post.find(params[:post_id])
            @tags = @post.tags.to_a
            if @tags.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Could not load the tags for the unspecified resource"}, status: :bad_request                    
        end
    end
    
    
end