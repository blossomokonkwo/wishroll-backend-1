class Api::V2::Search::RollsController < APIController
    
    def index
        offset = params[:offset]
        limit = 15
        @rolls = Roll.fetch_multi(HashTag.search(params[:q]).limit(limit).offset(offset).pluck(:id))
        if @rolls.any?
            begin
                authorize_by_access_header!
                @current_user = current_user                
            rescue => exception
                
            end                     




            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    

end