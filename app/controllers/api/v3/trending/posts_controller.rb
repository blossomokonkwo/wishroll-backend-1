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
            # trending_users = [13213, 9706, 318, 14645, 14652, 33, 598, 8715, 1912, 10869, 4493, 13191, 14512, 2856, 13090, 4662, 8569, 140, 10224, 13265, 14562, 123, 6070, 2931, 4161, 13139, 7959, 14405, 2934, 851, 11864, 4642, 13796, 5466, 1658, 101, 7176, 11912, 13594, 5500, 14441, 392, 3673, 11474, 13799, 114, 13707, 6293, 13426, 14363, 3290, 13213, 14413, 213, 13650, 871, 362, 3636, 1649, 1798, 5834, 11907, 8472, 6549, 1256, 4635, 768, 749, 315, 3266, 11578, 7980, 2192, 680, 9311, 13581, 10023, 4868, 14431, 1478, 3044, 5916, 10749, 7377, 293, 4304, 7143, 430, 8829, 14493, 4930, 4267, 12824, 870, 2963, 3127, 12822, 11715, 13585, 14182, 6908, 13422, 5378, 13634, 16698, 13605, 6886, 12562, 14426, 4853, 2694, 478, 2890, 1924, 7891, 1792, 2997, 6606]
            @posts = Post.includes([:board]).joins(:user).where(restricted: false).where.not(user: @current_user.blocked_users.select(:id)).where.not(user: @current_user.blocker_users.select(:id)).where.not(id: @current_user.reported_posts).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(limit) 

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