require './lib/plant.rb'

# stub
class CDFReader
  def self.read(plant, i, j)
    case plant.name
    when "spring_wheat" then 0
    when "soybean" then 0
    when "corn" then 73
    when "brazil_sugarcane" then 73
    when "vegtype" then 2
    end
  end
end

describe Plant do
  let(:plant) { Plant.new "spring_wheat" }

  describe "#new" do
    [:latitude, :longitude, :lat_i, :lat_j, :lng_i, :lng_j, :code, :file, :info].each do |method|
      it "resond to #{method}" do
        expect(plant.respond_to?(method)).to be_true
      end
    end
  end

  describe "#cover?" do
    context "when cover" do
      it { expect(plant.cover?(30, -70)).to be_true }
    end

    context "when don't cover" do
      it { expect(plant.cover?(0, 0)).to be_false }
    end
  end

  describe "#find_if_cover" do
    context "when cover" do
      it "returns 0" do
        expect(plant.find_if_cover(30, -70)).to eq 0
      end
    end

    context "when don't cover" do
      it "returns nil" do
        expect(plant.find_if_cover(0, 0)).to be_nil
      end
    end
  end
end

