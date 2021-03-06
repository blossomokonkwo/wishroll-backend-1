class CreateLocationJob < ApplicationJob
    def perform(ip, timezone, locateable_id, locateable_type)
        logger.info {"Searching for location with ip address #{ip}"}
        if ip and result = Geocoder.search(ip).first
            logger.debug {"Found location matching the specified ip address: #{result.inspect}"}
            begin
                ActiveRecord::Base.connected_to(role: :writing) do
                    location = Location.create!(locateable_id: locateable_id, locateable_type: locateable_type, ip: ip, country: result.country, city: result.city, region: result.region, timezone:  result.data['timezone'] || timezone, postal_code: result.postal_code, latitude: result.latitude, longitude: result.longitude)
                    logger.debug {"Location created: #{location.attributes.inspect}"}   
                end
            rescue => exception
                logger.fatal {"Couldn't Create location: #{exception}"}
            end
        else
            logger.debug {"Unable to find location result that matched the specified ip address: #{ip}"}
        end
    end
    
end