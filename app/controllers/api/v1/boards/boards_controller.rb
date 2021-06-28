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
        
    end
    
    def destroy
        @object = Object.find(params[:id])
        if @object.destroy
            flash[:success] = 'Object was successfully deleted.'
            redirect_to objects_url
        else
            flash[:error] = 'Something went wrong'
            redirect_to objects_url
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
        @boards = current_user.boards.limit(limit).offset(offset).to_a # Cache this request later using a custom cache method for a user's boards
        if @boards.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    
end