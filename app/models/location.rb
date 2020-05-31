class Location < ApplicationRecord
  require 'continent'
  include Continent
  belongs_to :locateable, polymorphic: true


  def country_name
    Continent.by_alpha_2_code(country)[:name]
  end

  def continent_code
    Continent.by_alpha_2_code(country)[:continent_codes][0]
  end

  def continent
    Continent.continent_name(continent_code)
  end
  
  
  
























  
end
