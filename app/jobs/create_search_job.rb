class CreateSearchJob < ApplicationJob
    def perform(result_type, query, ip_address, timezone)
        ActiveRecord::Base.connected_to(role: :writing) do
            begin
                search = Search.create!(query: query, result_type: result_type)
            rescue => exception
                search = Search.find_by(query: query, result_type: result_type)
                if search
                    search.occurences += 1
                    search.save!
                end
            end
            CreateLocationJob.perform_now(ip_address, timezone, search.id, search.class.name)
        end
    end
    
end