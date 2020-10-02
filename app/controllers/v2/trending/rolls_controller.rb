class V2::Trending::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending
        render json: nil, status: :not_found
    end
end