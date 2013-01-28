require './lib/c_d_f_reader.rb'
require 'yaml'

class Plant
  VEGTYPE_NUM = 15
  SUGARCANE_NUM = 110
  MIN_NUM = 0.01

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

  def cover?(coord)
    latitude.include?(coord.latitude) && longitude.include?(coord.longitude)
  end

  def find_at(coord)
    remaped_lng = Coordinates.remap_range coord.longitude, @lng_low, @lng_high, @lng_i, @lng_j
    remaped_lat = Coordinates.remap_range coord.latitude, @lat_high, @lat_low, @lat_i, @lat_j # i == 0 where lat is at its lowest value

    CDFReader.read self, remaped_lng, remaped_lat
  end

  def find_if_cover(coord)
    find_at coord if cover? coord
  end

  def self.springwheat_found?(coordinates)
    us_springwheat_num = self.new(:spring_wheat).find_if_cover coordinates

    !us_springwheat_num.nil?
  end

  def self.soybean_found?(coordinates)
    us_soybean_num = Plant.new(:soybean).find_if_cover coordinates

    !us_soybean_num.nil? && us_soybean_num < MIN_NUM
  end

  def self.corn_found?(coordinates)
    us_corn_num = Plant.new(:corn).find_if_cover coordinates

    !us_corn_num.nil? && us_corn_num > MIN_NUM
  end

  def self.brazil_sugarcane_found?(coordinates)
    braz_sugarcane_num = Plant.new(:brazil_sugarcane).find_if_cover coordinates

    !braz_sugarcane_num.nil? && braz_sugarcane_num < SUGARCANE_NUM
  end
end
