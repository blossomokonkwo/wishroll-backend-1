class Api::V1::Mutuals::MutualRelationshipRequestsController < APIController
    before_action :authorize_by_access_header!

    #  Create a new MutualRelationshipRequest Record. The current user is the requesting user and the requested user is obtained via the params hash.
    def create
        # First Ensure that there is no blocked relationship
        if requested_user = User.fetch(params[:requested_user_id]) and !(requested_user.blocked?(current_user) or current_user.blocked?(requested_user))
            
            # Ensure that both users aren't already mutuals
            unless requested_user.mutual?(current_user)
                @request = MutualRelationshipRequest.new(requesting_user: current_user, requested_user_id: params[:requested_user_id])
                if @request.save
                    render json: nil, status: :created
                else
                    render json: {error: @request.errors.full_messages}, status: :bad_request
                end
            else
                render json: {error: "Requesting user and the current user are already mutuals"}, status: :bad_request
            end
        else
            render json: {error: "Requested user and current user are blocked"}, status: :forbidden
        end
    end

    # Destroy a mutual request. Only the requesting user can destroy a request using this method. The requested user can deny a request - which destroys a request object - using the deny_request method.
    # Useful when a requesting user changes their mind on a request
    def destroy
        if @request = MutualRelationshipRequest.find_by(requesting_user: current_user, requested_user_id: params[:requested_user_id])
            if @request.destroy
                render json: nil, status: :ok
            else
                render json: {error: @request.errors.full_messages}, status: :bad_request
            end 
        else
            render json: nil, status: :not_found
        end
    end

    # Returns all of the requests that the current user has recieved but has not taken an action on (Accept or Deny).
    def pending_requests
        if @requests = current_user.recieved_mutual_reltationship_requests
            render :pending_requests, status: :ok
        else
            render json: nil, status: :not_found
        end
    end 

    # Returns all of the pending requests that the current user has sent
    def sent_requests
        if @requests = current_user.sent_mutual_relationship_requests
            render :sent_requests, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    

    # Accepting a request creates a mutual relationship between a requesting user and the requested user. The request record is destroyed in the DB after the relationship is created. 
    def accept_request
        # Find the request and check that the requested user id is equal to the current user (Only Requested users can accept a request).
        if @request = MutualRelationshipRequest.find_by(requesting_user_id: params[:requesting_user_id], requested_user: current_user)
            if requesting_user = @request.requesting_user and @request.requested_user == current_user and !(requesting_user.blocked?(current_user) or current_user.blocked?(requesting_user))
                @mutual_relationship = MutualRelationship.new(user: @request.requesting_user, mutual: @request.requested_user)
                if @mutual_relationship.save
                    @request.destroy # Can move this action to a background job
                    render json: nil, status: :created
                else
                    render json: {error: @mutual_relationship.errors.full_messages}, status: :bad_request
                end
            else
                render json: {error: "Forbidden"}, status: :forbidden
            end
        else
            render json: nil, status: :not_found
        end  
    end

    def deny_request
        # Denying a request is simply destroying the request record. All pending requests exist as records. Accepting a request creates a new mutual relationship between the requester and the requested.  
        if @request = MutualRelationshipRequest.find_by(requesting_user_id: params[:requesting_user_id], requested_user: current_user)
            if @request.destroy
                render json: nil, status: :ok
            else
                render json: nil, status: :bad_request
            end
        else
            render json: nil, status: :not_found
        end
    end


    
    
    





end