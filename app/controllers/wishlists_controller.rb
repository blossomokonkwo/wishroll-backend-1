class WishlistsController < ApplicationController
  before_action :authorize_by_access_header!
  def create
    @wishlist = Wishlist.new(user_id: current_user.id, name: params[:name])
    if @wishlist.save
      render json: nil, status: 200
    else
      render json: {error: "Your wishlist could not be created at this time"}, status: 400
    end
  end

  def show
    #this method renders out a wishlist and its attributes along with any wishes 
    @wishlist = Wishlist.find(params[:id])
    @wishes = @wishlist.wishes
    render :show, status: 200
  end

  def index
    #this method renders out all the wishlists that a user has
    @wishlists = Wishlist.find_by(user_id: params[:user_id]) #rails automatically renders a 404 if the where clause returns nil
    render :index, status: 200
  end

  def update_wishlist_name
    @wishlist = Wishlist.find_by(id: params[:id], user_id: current_user.id)
    if @wishlist #only current users can update a wishlist
      @wishlist.update!(name: params[:name]) #for now, users can only update a wishlist's name attribute
    #catch an update exception
    render json: nil, status: 200
    else
      render json: {error: "Couldn't find the wislist with id #{params[:id]}"}, status: 404
    end
  end

  def destroy
    @wishlist = Wishlist.find_by(id: params[:id], user_id: current_user.id) #only current users can destroy a wishlist
    if @wishlist.destroy
      render json: nil, status: 200
    else
      render json: {error: "Your wishlist could not be deleted at this time"}, status: 400
    end
  end

end
