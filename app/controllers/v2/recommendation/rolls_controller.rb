class V2::Recommendation::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 15
        offset = params[:offset]
        @id = current_user.id
        @roll = Roll.find(params[:roll_id])
        keywords = Array.new
        english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in"]
        @roll.tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "%#{t}%"}}
        caption_terms = @roll.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "%#{word}%"}
        @rolls = Roll.joins(:tags).where("tags.text ILIKE ANY (array[?]) OR rolls.caption ILIKE ANY (array[?])", keywords, keywords).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        @rolls.delete_if do |p|
            p.id == @roll.id or current_user.reported_rolls.include?(p) or p.user.blocked_users.include?(current_user) or current_user.blocked_users.include?(p.user)
        end
        if @rolls.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end