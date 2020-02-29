class AdminUser < ApplicationRecord
    has_secure_password
    validates: :email, presence: true, uniqueness: {message: "This email address is already registered with an admin account"}
    validates: :fullname, presence: true
    validates: :password, length: {minimum:12, maximum:72}
end