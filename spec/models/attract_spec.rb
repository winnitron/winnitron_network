require "rails_helper"

describe Attract do
  it "inits starts_at" do
    attract = Attract.new
    attract.valid?
    expect(attract.starts_at).to eq Time.now.utc.beginning_of_day
  end

  it "does not overwrite starts_at" do
    start = 3.days.ago
    attract = Attract.new(starts_at: start)
    attract.valid?
    expect(attract.starts_at).to eq start
  end

  it "disallows faster-than-light travel" do
    attract = Attract.new(ends_at: 24.hours.ago, starts_at: Time.now)
    attract.valid?
    expect(attract.errors[:base]).to include "The start must be earlier than the end."
  end

  describe "#started?" do
    it "is false if it starts in the future" do
      attract = Attract.new(starts_at: 24.hours.from_now)
      expect(attract.started?).to eq false
    end

    it "is true if it started in the past" do
      attract = Attract.new(starts_at: 24.hours.ago)
      expect(attract.started?).to eq true
    end
  end

  describe "#ended?" do
    it "is false if there is no ends_at" do
      expect(Attract.new.ended?).to eq false
    end

    it "is false if it ends in the future" do
      attract = Attract.new(ends_at: 24.hours.from_now)
      expect(attract.ended?).to eq false
    end

    it "is true if it started in the past" do
      attract = Attract.new(ends_at: 24.hours.ago)
      expect(attract.ended?).to eq true
    end
  end

  describe "#active?" do
    it "is true if started not ended" do
      attract = Attract.new(starts_at: 24.hours.ago, ends_at: 24.hours.from_now)
      expect(attract.active?).to eq true
    end

    it "is true if it NEVER ENDS, GOD" do
      attract = Attract.new(starts_at: 24.hours.ago)
      expect(attract.active?).to eq true
    end

    it "is false if not started" do
      attract = Attract.new(starts_at: 24.hours.from_now, ends_at: 48.hours.from_now)
      expect(attract.active?).to eq false
    end

    it "is false if ended" do
      attract = Attract.new(starts_at: 48.hours.ago, ends_at: 24.hours.ago)
      expect(attract.active?).to eq false
    end
  end
end
