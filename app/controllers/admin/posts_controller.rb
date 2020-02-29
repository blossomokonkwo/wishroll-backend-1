module Admin
  class Admin::PostsController < Admin::AdminController 
   def update
       @post = Post.find(params[:id])
       if @post.update(post_params)
         render json: nil, status: :ok
       else
        render json: {error: "Post could not be created"}
       end
   end
   def show
    @post = Post.find(params[:id])
    end
  def index
    @posts = Post.all
    render "admin/posts/index.json.jbuilder", status: :ok
  end

   def destroy
       @post = Post.find(params[:id])
       if @post.destroy
           render json: nil, status: :ok
       else
          render json: {error: "Could not delete post"}, status: 400
       end
   end

   def report
    
   end

   private 
   def post_params
     params.permit :caption, :post_image, :original_post_id
   end
    
  end  
end
