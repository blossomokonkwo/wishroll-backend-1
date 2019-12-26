ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_and_return_tokens
    post login_url, params: {email: "gboyokonkwo35@gmail.com", password: "greatokonkwo"}
    tokens = @response.body 
    return tokens
  end
end
