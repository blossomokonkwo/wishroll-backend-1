class Api::V1::Boards::BoardsController < APIController
    before_action :authorize_by_access_header!
    def create
        # Create a new board given a name and an optional description from the params hash
        board = Board.new(name: params[:name], description: params[:description], avatar: params[:avatar], banner: params[:banner])
        if board.save
            # Create the initial board member with admin privileges             
            board_member = board.board_members.create(user: current_user)
            # Set initial board member as admin
            board_member.is_admin = true
            board_member.save
            board.avatar_url = url_for(board.avatar) if board.avatar.attached?
            board.banner_url = url_for(board.banner) if board.banner.attached?
            if board.save
                render json: nil, status: :created
            else
                render json: nil, status: :internal_server_error
            end
        else
            render json: {error: "Unable to create a new board: #{board.errors.full_messages.inspect}"}, status: :bad_request
        end
    end

    def update
        board_id = params[:id]
        # Authorization
        # Authorize that a user is a member of a board and that they are the board admin.
        if board_member = BoardMember.find_by(board_id: board_id, user: current_user) and board_member.is_admin

            @board = Board.find(board_id)

            @board.update(update_params)

            if params[:avatar] and @board.avatar.attached?
                @board.update!(avatar_url: url_for(@board.avatar))
            end

            if params[:banner] and @board.banner.attached?
                @board.update!(banner_url: url_for(@board.banner))         
            end

            render json: nil, status: :ok
        else
            render json: nil, status: :unauthorized
        end
    end

    def destroy_avatar
        board_id = params[:board_id]
        
        if board_member = BoardMember.find_by(board: board_id, user: current_user) and board_member.is_admin

            @board = Board.find(board_id)

            if @board.avatar.attached?
                @board.avatar.purge_later
                @board.update(avatar_url: nil)
                render json: nil, status: :ok
            else
                render json: nil, status: :unprocessable_entity
            end
        else
            render json: nil, status: :unauthorized
        end 
    end

    def destroy_banner
        board_id = params[:board_id]

        if board_member = BoardMember.find_by(board: board_id, user: current_user) and board_member.is_admin

            @board = Board.find(board_id)

            if @board.banner.attached?
                @board.banner.purge_later
                @board.update(banner_url: nil)
                render json: nil, status: :ok
            else 
                render json: nil, status: :not_found
            end
        else
            render json: nil, status: :unauthorized
        end
    end
    
    
    def destroy
        if board = Board.find(params[:id])
            if board_member = BoardMember.find_by(board: board, user: current_user) and board_member.is_admin
                if board.destroy
                    render json: nil, status: :ok
                else
                    render json: nil, status: :internal_server_error
                end
            else
                render json: nil, status: :not_found
            end
        else
            render json: nil, status: :not_found
        end
    end
    
    def show
        if @board = Board.fetch(params[:id])
            current_user # Call the current user method
            render :show, status: :ok
        else
            render json: {error: "Couldn't find board with id: #{params[:id]}"}
        end

    end

    # Return all of the boards that a user is a member of
    def index
        limit = params[:limit] || 0
        limit = 25 if limit.to_i > 25
        offset = params[:offset] || 0
        # @boards = current_user.boards.limit(limit).offset(offset).to_a # Cache this request later using a custom cache method for a user's boards
        @boards = Board.limit(limit).offset(offset).order(board_member_count: :desc).to_a #Return all boards for now
        if @boards.any?
            current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    private def update_params
        params.permit(:name, :description, :avatar, :banner, :id)
    end
    
    
end