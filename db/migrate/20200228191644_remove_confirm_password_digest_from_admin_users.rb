class RemoveConfirmPasswordDigestFromAdminUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :admin_users, :confirm_password_digest
  end
end
