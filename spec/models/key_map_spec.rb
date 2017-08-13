require "rails_helper"

RSpec.describe KeyMap, type: :model do
  let(:key_map) { KeyMap.new }

  before :each do
    allow(key_map).to receive(:game).and_return(double(max_players: 4))
  end

  describe "#bindings" do
    it "returns template for non-custom" do
      key_map.template = "default"
      expect(key_map.bindings).to eq KEY_MAP_TEMPLATES[:default]
    end

    it "slices off extra players" do
      allow(key_map).to receive(:game).and_return(double(max_players: 2))
      expect(key_map.bindings).to eq KEY_MAP_TEMPLATES[:default].slice("1", "2")
    end

    it "returns custom map" do
      key_map.template = "custom"
      key_map.custom_map = { "1" => { "down" => "s" } }
      key_map.save
      expect(key_map.bindings).to eq("1" => { "down" => "s" })
    end
  end

end