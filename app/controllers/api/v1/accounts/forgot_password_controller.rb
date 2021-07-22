class Api::V1::Accounts::ForgotPasswordController < APIController
    
    def reset_password
        if user = User.find_by(email: params[:email])
            if new_password = params[:password]
                user.update!(password: new_password) 
                render json: nil, status: :ok
            else 
                render json: {error: "Missing Password"}, status: :bad_request
            end
        else
            render json: {error: "User not found with email address: #{params[:email]}"}, status: :not_found
        end
    end
    
end