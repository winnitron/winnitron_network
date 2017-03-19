require "rails_helper"

describe Search do

  let!(:games) do
    games = FactoryGirl.create_list(:game, 3)

    games[0].title = "First Best Game Ever"
    games[0].tag_list = "official,1v1,good"

    games[1].title = "Second Game Ever"
    games[1].tag_list = "official,great"

    games[2].title = "Nobody likes this game"
    games[2].tag_list = "pretty,bad,actually"

    games.each { |g| g.save! }
  end

  describe "search by tag" do
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

  describe "search by title" do
    let(:search) { Search.new(Game, "Best Game Ever") }

    it "does not include games that do not match a keyword" do
      nonmatch = FactoryGirl.create(:game, title: "something else")
      expect(search.results).to_not include(nonmatch)
    end

    it "gives a unique list" do
      expect(search.results).to eq search.results.uniq
    end

    it "sorts results by matching keywords" do
      expect(search.results).to eq games
    end

    it "is case insensitive" do
      expect(search.results).to include(games[2])
    end
  end

  describe "sorting with both title and tags" do
    let(:search) { Search.new(Game, "first ever official actually") }

    it "does the right thing" do
      expect(search.results).to eq games
    end
  end

  it "saves the search" do
    user = FactoryGirl.create(:user)
    Search.new(Game, "first ever official", user).results

    event = LoggedEvent.last
    expected_details = {
      "query"    => "first ever official",
      "keywords" => %w(first ever official)
    }
    expect(event.actor).to eq user
    expect(event.details).to eq expected_details
  end


end