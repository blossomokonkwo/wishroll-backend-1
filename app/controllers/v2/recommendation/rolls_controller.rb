class V2::Recommendation::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        render json: nil, status: :not_found
    end
    
    
end