require './lib/c_d_f_reader.rb'
require 'yaml'

class Plant

  attr_reader :latitude, :longitude, :lat_i, :lat_j, :lng_i, :lng_j, :code, :file, :info, :name

  def initialize(name)
    @name = name.to_s
    @info = YAML.load_file("data/plants.yml")["plants"][@name]
    @info.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
    @latitude = @lat_low..@lat_high
    @longitude = @lng_low..@lng_high
  end

  def cover?(lat, lng)
    latitude.include?(lat) && longitude.include?(lng)
  end

  def find_at(lat, lng)
    remaped_lng = Coordinates.remap_range lng, @lng_low, @lng_high, @lng_i, @lng_j
    remaped_lat = Coordinates.remap_range lat, @lat_high, @lat_low, @lat_i, @lat_j # i == 0 where lat is at its lowest value

    CDFReader.read self, remaped_lng, remaped_lat
  end

  def find_if_cover(lat, lng)
    find_at lat, lng if cover? lat, lng
  end
end
