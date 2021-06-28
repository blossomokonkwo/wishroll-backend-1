class AddUuidToBoardsAndBoardPosts < ActiveRecord::Migration[6.1]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :boards, :uuid, :uuid, null: false, default: 'gen_random_uuid()', after: :id
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")

    add_column :board_posts, :uuid, :uuid, null: false, default: 'gen_random_uuid()', after: :id
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
