class Api::V1::Boards::BoardMembersController < APIController
    before_action :authorize_by_access_header!
    def create
        @board_member = Board.find(params[:board_id]).board_members.create(user: current_user)
        if @board_member.save
          render json: nil, status: :created
        else
          render json: {error: @board_member.error.full_messages.inspect}, status: :bad_request
        end
    end
    

    def destroy
      board_id = params[:board_id]
      if board_member_id = params[:id]
        board_member = BoardMember.find(board_member_id)
      elsif user_id = params[:user_id]
        board_member = BoardMember.find_by!(board_id: board_id, user_id: user_id)
      else
        board_member = BoardMember.find_by!(board_id: board_id, user: current_user)
      end
      # Ensure that the current user has permission to delete a board member (Remove a user from a board). Only Admins and the current_user can remove themselves or others from the board.
      if board_member.user_id == current_user.id or BoardMember.find_by!(board_id: board_id, user: current_user).is_admin
        if board_member.destroy
          render json: nil, status: :ok
        else
          render json: nil, status: :bad_request
        end
      else
        render json: nil, status: :unauthorized
      end
    end
    
    def update
      
    end
    

    def index
        limit = params[:limit] || 25
        limit = 10 if limit.to_i > 10 # Upper limit is 10. Since this query also includes a User retrieval it is more expensive and requires a lower limit.
        offset = params[:offset] || 0
        @board_members = Board.fetch(13).board_members.includes(:user).limit(limit).offset(offset)
        if @board_members.any?
          render :index, status: :ok
        else
          render json: nil, status: :not_found
        end
    end
    
    
    
    
end