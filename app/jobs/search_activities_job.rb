class SearchActivitiesJob < ApplicationJob
    def perform(query:, user_id:, content_type:)
        if user = User.fetch(user_id)
            ActiveRecord::Base.connected_to(role: :writing) do
                begin
                    case content_type
                    when "image"
                        result_type 0
                    when "video"
                        result_type = 1
                    when "gif"
                        result_type = 2
                    when "audio"
                        result_type = 3
                    when "user"
                        result_type = 4
                    when "location"
                        result_type = 5
                    else
                        result_type = 6
                    end
                    user.searches.create!(query: query, result_type: result_type)
                rescue => exception
                    if search = Search.find_by(query: query, user: user, result_type: result_type)
                        search.occurences += 1
                        search.save!
                    end
                    logger.debug {"Couldn't create a Search object for query #{query} #{exception}"}
                end
            end
        end
    end
    
end