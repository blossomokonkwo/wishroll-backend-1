class CreateLocationJob < ApplicationJob
    def perform(ip, timezone, locateable_id, locateable_type)
        logger.info {"Searching for location with ip address #{ip}"}
        if !ip or !timezone
            logger.debug {"Missing either an ip address or the timezone for the record"}
            return
        end
        results = Geocoder.search(ip)
        if !results
            logger.debug {"Unable to find location result that matched the specified ip address: #{ip}"}
            return
        end
        logger.debug {"Found locations matching the specified ip address: #{results.inspect}"}
        result = results.first
        if result
            begin
            city = result.city; country = result.country; region = result.state; postal_code = result.postal_code
            lattitude = result.latitude; longitude = result.longitude
            location = Location.new(locateable_id: locateable_id, locateable_type: locateable_type)
            location.ip = ip; location.city = city
            location.country = country; location.region = region; location.timezone = timezone
            location.postal_code = postal_code; location.latitude = lattitude; location.longitude = longitude
            if location.save
                logger.debug {"Location created: #{location.attributes.inspect}"}                
            else
                logger.fatal {"Couldn't Create location: #{location.errors.inspect}"}
            end 
                logger.debug {"Location country: #{location.country_name}"}
            rescue => exception
                logger.fatal {"Couldn't Create location: #{location.errors.inspect}"}
                return
            end
        end
    end
    
end