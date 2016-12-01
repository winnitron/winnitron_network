require "rails_helper"

describe Search do

  let!(:games) do
    games = FactoryGirl.create_list(:game, 3)
    games[0].tag_list = "official,1v1,good"
    games[1].tag_list = "official,great"
    games[2].tag_list = "pretty bad actually"
    games.each { |g| g.save! }
  end

  describe "#results" do
    let(:search) { Search.new(Game, "official 1v1") }

    it "finds items that have at least one of the tags" do
      expect(search.results).to include(games[0])
      expect(search.results).to include(games[1])
    end

    it "does not find items that have none of the tags" do
      expect(search.results).to_not include(games[2])
    end

    it "gives a unique list" do
      expect(search.results).to eq search.results.uniq
    end

    it "sorts the results by matching tag count" do
      expect(search.results).to eq [games[0], games[1]]
    end
  end
end