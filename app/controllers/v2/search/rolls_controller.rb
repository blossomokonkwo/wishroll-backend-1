class V2::Search::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = params[:limit]
        query = params[:q]
        offset = params[:offset]

    end
    

end