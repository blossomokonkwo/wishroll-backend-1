class ApplicationJob < ActiveJob::Base
    rescue_from ActiveJob::DeserializationError do |exception|
            #handle missing record error
            puts exception
    end
end
