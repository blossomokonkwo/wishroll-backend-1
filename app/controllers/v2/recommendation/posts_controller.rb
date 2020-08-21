class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 9
        offset = params[:offset]
        render json: nil, status: :not_found
    end
    
    
end