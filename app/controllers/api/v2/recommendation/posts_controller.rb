class Api::V2::Recommendation::PostsController < APIController

    def index
        limit = 9
        offset = params[:offset]
        render json: nil, status: :not_found
    end
    
    
end