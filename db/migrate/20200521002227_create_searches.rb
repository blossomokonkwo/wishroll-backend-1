class CreateSearches < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :searches, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.text :query
      t.references :searhable, polymorphic: true, type: :uuid
      t.bigint :occurences


      t.timestamps
    end
    add_index :searches, :query
    #Ex:- add_index("admin_users", "username")
  end
end
