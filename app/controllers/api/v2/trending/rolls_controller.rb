class Api::V2::Trending::RollsController < APIController
    before_action :authorize_by_access_header!
    def trending
        render json: nil, status: :not_found
    end
end