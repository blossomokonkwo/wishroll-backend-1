class Api::V3::Privacy::ReportPostsController < APIController
    def create
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!

            # set the @current_user instance variable
            @current_user = current_user

            reported_post = ReportPost.create!(post_id: params[:post_id], user: @current_user, reason: params[:reason]) 

            if reported_post 
                render json: nil, status: :ok
            else
                render json: {error: "There was an error reporting this post"}, status: 400
            end

        rescue => exception
            render json: {error: "An error occured #{exception}"}, status: 500
        end
    end
    
end