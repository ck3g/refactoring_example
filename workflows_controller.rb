require 'json'
require './lib/plant.rb'
require './lib/coordinates.rb'
require './lib/ecosystem.rb'

class WorkflowsController
  attr_accessor :params

  def get_biome
    lng = params[:lng].to_i
    lat = params[:lat].to_i

    ## US SpringWheat
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (24.75 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    # http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75 # => 0.0956562

    spring_wheat = Plant.new :spring_wheat
    us_springwheat_num = spring_wheat.find_if_cover lat, lng

    ## US Soybean
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (24.75 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    soybean = Plant.new :soybean
    us_soybean_num = soybean.find_if_cover lat, lng

    ## US Corn
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (25.25 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    # http://localhost:3000/get_biome?lng=-83.25&lat=44.25 # => 0.18501955270767212
    corn = Plant.new :corn
    us_corn_num = corn.find_if_cover lat, lng

    ## Brazil Sugarcane
    # This map has an ij coordinate range of (0,0) to (59, 44)
    # top left LatLng being (-60.25 ,-4.75)
    # bottom right LatLng being (-30.75 ,-26.75)
    # Therefore it sits between:
    # Lat -4.75 and -26.75
    # Lon -30.75 and -60.25
    brazil_sugarcane = Plant.new :brazil_sugarcane
    braz_sugarcane_num = brazil_sugarcane.find_if_cover lat, lng

    ## Vegtype
    # This map has an ij coordinate range of (0,0) to (720, 360)
    # top left LatLng being (89.75, -179.25)
    # top left LatLng being (-89.75, 179.25)
    # Therefore it sits between:
    # Lat -89.75 and 89.75
    # Lon -179.25 and 179.25
    vegtype = Plant.new :vegtype
    biome_num = vegtype.find_at lat, lng

    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p ecosystems[0] # will return a Hash
    # p ecosystems[0]["category"] # => "native"

    biome_data = {}
    if biome_num <= 15
      biome_data["native"] = Ecosystem.load_json[biome_num]
    end

    biofuel_names = []
    agroecosystem_names = []
    ############ Here we set the threshold levels ############
    if us_springwheat_num != nil
      agroecosystem_names << "spring wheat"
    end
    # should include spring wheat in the JSON:
    # http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75

    if us_soybean_num != nil && us_soybean_num < 0.01
      biofuel_names << "soybean"
    end
    # should include soybean in the JSON:

    # should NOT include soybean in the JSON:


    if us_corn_num != nil && us_corn_num > 0.01
      biofuel_names << "corn"
    end
    # should include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-95.25&lat=44.25
    # should NOT include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-71.25&lat=33.75

    if braz_sugarcane_num != nil && braz_sugarcane_num < 110
      biofuel_names << "brazil sugarcane"
    end

    biome_data["biofuels"]       = { "name"=> biofuel_names.join(",") }
    biome_data["agroecosystems"] = { "name"=> agroecosystem_names.join(",") }

    # respond_to do |format|
    #   format.json { render json: biome_data }
    # end

    biome_data
  end
end
