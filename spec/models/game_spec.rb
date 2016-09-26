require "rails_helper"

RSpec.describe Game, type: :model do
  describe "player counts" do
    it "defaults to 1-1" do
      game = Game.new
      game.valid?
      expect(game.min_players).to eq 1
      expect(game.max_players).to eq 1
    end

    it "automatically sets max" do
      game = Game.new(min_players: 2)
      game.valid?
      expect(game.max_players).to eq 2
    end

    it "requires max >= min" do
      game = Game.new(min_players: 5, max_players: 2)
      expect(game).to_not be_valid
      expect(game.errors[:max_players]).to_not be_empty
    end

  end
end