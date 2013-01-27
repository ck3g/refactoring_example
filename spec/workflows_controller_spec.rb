require './workflows_controller.rb'

describe WorkflowsController do
  let(:workflows) { WorkflowsController.new }

  describe "#get_biome" do

    context "when lat: 30 and lgn: -70" do
      before do
        workflows.params = { lat: 30, lng: -70 }
      end

      let(:biomes) do
        {
          "native" => Ecosystem.load_json[2],
          "biofuels" => { "name" => "soybean,corn" },
          "agroecosystems" => { "name" => "spring wheat" }
        }
      end

      it "gets northen peatland, soybean, corn and spring wheat" do
        expect(workflows.get_biome).to eq biomes
      end
    end

    context "when lat: -15 and lgn: -40" do
      before do
        workflows.params = { lat: -15, lng: -40 }
      end

      let(:biomes) do
        {
          "native" => Ecosystem.load_json[2],
          "biofuels" => { "name" => "brazil sugarcane" },
          "agroecosystems" => { "name" => "" }
        }
      end

      it "gets northen peatland and brasil sugarcane" do
        expect(workflows.get_biome).to eq biomes
      end
    end
  end
end
