require './lib/plant.rb'
require './lib/coordinates.rb'
require './lib/ecosystem.rb'

class Biome
  def self.data(coordinates)
    agroecosystem_names = []
    agroecosystem_names << "spring wheat" if Plant.springwheat_found? coordinates

    biofuel_names = []
    biofuel_names << "soybean" if Plant.soybean_found? coordinates
    biofuel_names << "corn" if Plant.corn_found? coordinates
    biofuel_names << "brazil sugarcane" if Plant.brazil_sugarcane_found? coordinates

    biome_data = {}
    biome_num = Plant.new(:vegtype).find_at coordinates
    if biome_num <= Plant::VEGTYPE_NUM
      biome_data["native"] = Ecosystem.load_json[biome_num]
    end
    biome_data["biofuels"]       = { "name"=> biofuel_names.join(",") }
    biome_data["agroecosystems"] = { "name"=> agroecosystem_names.join(",") }

    biome_data
  end
end
