json.wishlist do 
    json.name @wishlist.name
    json.wishes_count @wishlist.wishes_count
    json.total_amount_raised @wishlist.total_amount_raised
    json.created_at @wishlist.created_at
    json.updated_at @wishlist.updated_at
end
 
json.wishes @wishes, :product_name, :price, :amount_covered, :description, :image_url, :created_at, :updated_at

