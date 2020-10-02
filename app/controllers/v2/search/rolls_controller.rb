class V2::Search::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        render json: nil, status: :not_found
    end
    

end