class Api::V2::AnnouncementsController < APIController
    def create
        @announcement = Announcement.create
        @announcement.media_item.attach params[:media_item] if params[:media_item]
        @announcement.thumbnail_image.attach params[:thumbnail_image] if params[:thumbnail_image]
        @announcement.media_url = polymorphic_url(@announcement.media_item) if @announcement.media_item.attached?
        @announcement.thumbnail_url = polymorphic_url(@announcement.thumbnail_image) if @announcement.thumbnail_image.attached?
        if @announcement.save
            render json: nil, status: :created
        else
            render json: nil, status: 400
        end
    end

    def index
        offset = params[:offset] || 0
        limit = 15
        @announcements = Announcement.offset(offset).limit(limit).to_a
        if @announcements.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def show
        if @announcement = Announcement.find(params[:id])
            render :show, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
    
end
