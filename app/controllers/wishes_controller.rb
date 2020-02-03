class WishesController < ApplicationController
  before_action :authorize_by_access_header!
  def create
    @wish = Wish.new(user_id: current_user.id, price: params[:price], description: params[:description],product_name: params[:product_name],wishlist_id: params[:wishlist_id])
    @wish.wish_picture = params[:wish_picture]
    if @wish.wish_picture.attached?
      @wish.image_url = url_for @wish.wish_picture 
      if @wish.save
        render json: nil, status: 201
      else
        render json: {:error => "There was an error with creating your wish"}, status: 400
      end
    else
      render json: {error: "Your wish must have a wish picture so others know what they're giving towards"}, status: 400
    end
  end

  def update_wish_picture
    @wish = Wish.find_by(id: params[:id], user_id: current_user.id)
    @wish.wish_picture = params[:wish_picture]
    if @wish.wish_picture.attached?
      @wish.image_url = url_for(@wish.wish_picture)
      @wish.save
      render json: nil, status: 200
    else
      render json: {error: "Your wish must have a wish picture so others know what they're giving towards"}, status: 400
    end
  end

  def update_wish_description
    @wish = Wish.find_by(id: params[:id], user_id: current_user.id)
    @wish.description = params[:description]
    if @wish.save
      render json: nil, status: 200
    else 
      render json: {error: "Your wish could not be updated at this time"}, status: 400
    end
  end

  def update_product_name
    @wish = Wish.find_by(id: params[:id], user_id: current_user.id)
    @wish.product_name = params[:name]
    if @wish.save
      render json: nil, status: 200
    else 
      render json: {error: "Your wish could not be updated at this time"}, status: 400
    end
  end

  def destroy
    @wish = Wish.find_by(id: params[:id], user_id: current_user.id)
    if @wish and @wish.destroy
      render json: nil, status: 200
    else
      render json: {error: "Unable to delete your wish"}, status: 400
    end
  end

  def show
    @wish = Wish.find(params[:id])
    render :show, status: 200
  end
end
