class RepliesController < ApplicationController
    def create
        #creates a sub-comment (reply) to a specific comment
        @object = Object.new(params[:object])
        if @object.save
          flash[:success] = "Object successfully created"
          redirect_to @object
        else
          flash[:error] = "Something went wrong"
          render 'new'
        end
    end

    def show
        #shows a specific reply (this method is optional and might not be needed because a user will never need to request a specific comment reply page)
        @ = .find()
    end

    def update
        #updates the content (body) of a specific reply
        @object = Object.find(params[:id])
        if @object.update_attributes(params[:object])
          flash[:success] = "Object was successfully updated"
          redirect_to @object
        else
          flash[:error] = "Something went wrong"
          render 'edit'
        end
    end

    def index
        #returns all the replies for a specific comment
        @ = .all
    end
    

    def destroy
        #destroys a specific reply
        @object = Object.find(params[:id])
        if @object.destroy
            flash[:success] = 'Object was successfully deleted.'
            redirect_to objects_url
        else
            flash[:error] = 'Something went wrong'
            redirect_to objects_url
        end
    end
    
    
    









    private 
    def reply_params
        params.permit :comment_id, :user_id, :post_id, :body
    end
    
end
