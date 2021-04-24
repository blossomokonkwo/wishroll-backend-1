class Api::V3::Recommendation::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 25
        offset = params[:offset]
        document_text = Roll.fetch(params[:roll_id]).hashtags.pluck(:text).flatten[0]
        @rolls = Roll.fetch_multi(Hashtag.recommend(document_text).limit(limit).offset(offset).pluck(:hashtaggable_id)).to_a
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            @rolls = Roll.where(restricted: false).order(popularity_rank: :desc, created_at: :desc).offset(offset).limit(limit).to_a
            if @rolls.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        end        
    end
    
end