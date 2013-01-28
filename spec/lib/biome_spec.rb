require './lib/biome.rb'

describe Biome do

  describe ".data" do

    context "when lat: 30 and lgn: -70" do
      let(:coordinates) { Coordinates.new 30, -70 }
      let(:biomes) do
        {
          "native" => Ecosystem.load_json[2],
          "biofuels" => { "name" => "soybean,corn" },
          "agroecosystems" => { "name" => "spring wheat" }
        }
      end

      it "gets northen peatland, soybean, corn and spring wheat" do
        expect(Biome.data(coordinates)).to eq biomes
      end
    end

    context "when lat: -15 and lgn: -40" do
      let(:coordinates) { Coordinates.new -15, -40 }
      let(:biomes) do
        {
          "native" => Ecosystem.load_json[2],
          "biofuels" => { "name" => "brazil sugarcane" },
          "agroecosystems" => { "name" => "" }
        }
      end

      it "gets northen peatland and brasil sugarcane" do
        expect(Biome.data(coordinates)).to eq biomes
      end
    end
  end
end
