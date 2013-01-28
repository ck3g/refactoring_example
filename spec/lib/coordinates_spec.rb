require './lib/coordinates.rb'

describe Coordinates do

  describe ".new" do
    let(:coordinates) { Coordinates.new 100, 200 }
    it "latitude is 100" do
      expect(coordinates.latitude).to eq 100
    end

    it "longitude is 200" do
      expect(coordinates.longitude).to eq 200
    end
  end

  describe "#remap_range" do
    context "when pass -70, -106, -65.25, 0, 80" do
      it "return 70" do
        expect(Coordinates.remap_range(-70, -106, -65.25, 0, 80)).to eq 70
      end
    end

    context "when pass 30, 49.75, 25, 0, 50" do
      it "return 39" do
        expect(Coordinates.remap_range(30, 49.75, 25, 0, 50)).to eq 39
      end
    end
  end
end
