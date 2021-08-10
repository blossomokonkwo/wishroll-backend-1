class Api::V1::Mutuals::MutualRelationshipsController < APIController
    before_action :authorize_by_access_header!

    # Return all of a users mutuals  
    def index
        limit = params[:limit]
        offset = params[:offset]
        if @mutuals = current_user.mutuals(limit: limit, offset: offset) and @mutuals.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    # Destroy a MutualRelationship record. 
    def destroy
        mutual_user_id = params[:mutual_user_id]
        if mutual_relationship = MutualRelationship.find_by("(mutual_id = #{mutual_user_id} AND user_id = #{current_user.id}) OR (mutual_id = #{current_user.id} AND user_id = #{mutual_user_id})")
            if mutual_relationship.destroy
                render json: nil, status: :ok
            else
                render json: nil, status: :bad_request
            end
        else
            render json: nil, status: :not_found
        end
    end


    
end