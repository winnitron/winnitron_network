require "rails_helper"

RSpec.describe KeyMap, type: :model do
  let(:key_map) { KeyMap.new }

  describe "#bindings" do
    it "returns template for non-custom" do
      key_map.template = "default"
      expect(key_map.bindings).to eq KEY_MAP_TEMPLATES[:default]
    end

    it "returns custom map" do
      key_map.template = "custom"
      key_map.set("P1_DOWN", "s")
      expect(key_map.bindings).to eq({ p1_down: "s" })
    end
  end

  describe "#set" do
    it "disallows invalid control" do
      expect {
        key_map.set("FAKE", "a")
      }.to raise_error ArgumentError
    end

    it "disallows invalid key" do
      expect {
        key_map.set("P1_UP", "foo")
      }.to raise_error ArgumentError
    end

    it "disallows on non-custom template" do
      key_map.template = "default"
      expect {
        key_map.set("P1_UP", "Up")
      }.to raise_error ArgumentError
    end

    it "sets valid binding on custom map" do
      key_map.template = "custom"
      key_map.set("P1_UP", "Down")
      expect(key_map.custom_map[:p1_up]).to eq "Down"
    end
  end

end