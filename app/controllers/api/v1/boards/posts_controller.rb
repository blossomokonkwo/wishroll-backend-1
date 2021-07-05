class Api::V1::Boards::PostsController < APIController
    before_action :authorize_by_access_header!

    # Create a post that belongs to a board. Ensure that the request if from a user that is a member of the board and that a media item is available.
    def create
        # Check that the user is authorized to post to the board.
        # The user must be a member of the board to create a post.
        if BoardMember.find_by(board_id: params[:board_id], user: current_user)

            # Check that the media_item is contained in the params hash. Every post must contain a media item (video, image, or GIF).
            if media_item = params[:media_item]

                # Create the post object given the params hash and media items
                @post = Post.create(board_id: params[:board_id], 
                        caption: params[:caption], 
                        user: current_user, 
                        restricted: current_user.restricted,
                        width: params[:width],  
                        height: params[:height], 
                        duration: params[:duration],
                        media_item: media_item,
                        thumbnail_item: params[:thumbnail_item]) # A thumbnail item is optional for videos and photos. However, it is helpful for displaying a preview of large images and videos.

                    # If the media item is attached, then create the media url using the url_for method.
                    if @post.media_item.attached?
                        @post.media_url = url_for(@post.media_item)
                    end

                    # If the thumbnail item is attached, then create the thumbnail url using the url_for method.
                    if @post.thumbnail_item.attached?
                        @post.thumbnail_item = url_for(@post.thumbnail_item) 
                    end               
                    
                if @post.save
                    render json: {post_id: @post.id}, status: :created          
                else
                    render json: nil, status: :bad_request
                end
            else
                render json: {error: "A post must contain a media item."}, status: :bad_request
            end
        else
            render json: {error: "You are not a member of this board."}, status: :unauthorized
        end
    end

    def index
        @board = Board.fetch(params[:board_id])
        limit = params[:limit] || 12
        offset = params[:offset] || 0
        @posts = @board.posts.limit(limit).offset(offset).order(created_at: :desc).to_a
        if @posts.any?
            current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end