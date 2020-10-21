class V3::Recommendation::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 15
        offset = params[:offset]
        document_text = Roll.fetch(params[:roll_id]).hashtags.pluck(:text).flatten[0]
        @rolls = Roll.fetch_multi(HashTag.recommend(document_text).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end        
    end
    
end