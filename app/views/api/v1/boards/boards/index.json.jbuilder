json.array! @boards.each do |board|
    json.id board.id
    json.uuid board.uuid
    json.name board.name
    json.description board.description
    json.created_at board.created_at
    json.updated_at board.updated_at
    json.member_count board.board_member_count
    json.is_featured board.featured
    json.avatar_url board.avatar_url
    json.banner_url board.banner_url
    json.is_member board.member?(@current_user)
end
