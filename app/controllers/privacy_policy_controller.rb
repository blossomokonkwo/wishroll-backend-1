class PrivacyPolicyController < ActionController::API
    def privacy
        render :privacypolicy, status: 200
    end
end