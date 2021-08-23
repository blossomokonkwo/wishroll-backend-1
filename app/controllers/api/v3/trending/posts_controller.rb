class Api::V3::Trending::PostsController < APIController
    
    def index
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!

            # set the @current_user instance variable
            @current_user = current_user

            # set the offset and limit
            offset = params[:offset]
            limit = 4
            trending_users = [5500, 2997, 4493, 123, 392, 4853, 7827, 1798, 5451, 4930, 140, 8667, 749, 1658, 11310, 2856, 1256, 10459, 10224, 362, 2732, 2032, 10023, 3936, 1027, 2931, 5166, 8034, 1608, 5760, 1912, 3044, 2192, 7281, 8715, 7959, 4161, 11924, 2101, 11602, 2976, 9007, 10698, 8569, 4135, 8093, 80, 1050, 1, 7891, 81, 7403, 1436, 12258, 11602, 5834, 11200, 10919, 265]
            @posts = Post.joins(:user).where(restricted: false).where(user_id: trending_users).where.not(user: @current_user.blocked_users.select(:id)).and(Post.where.not(id: @current_user.reported_posts)).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(limit) 

            # check that posts array isn't empty
            if @posts.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end

        rescue => exception
            # handle the case where a user isn't signed in to view their feed maybe recommending posts to the user
            puts exception
            @posts = Post.where(restricted: false).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(25)

            if @posts.any?
                render json: @posts, status: :ok
            else
                render json: nil, status: :not_found
            end
        end

    end
    
    
end