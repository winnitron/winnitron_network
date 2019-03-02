require "rails_helper"

describe FilteredHighScores do
  let(:machines) { FactoryBot.create_list(:arcade_machine, 2) }
  let(:games) { FactoryBot.create_list(:game, 2) }

  let!(:scores) do
    [
      FactoryBot.create(:high_score, arcade_machine: machines[0], game: games[0]),
      FactoryBot.create(:high_score, arcade_machine: machines[0], game: games[1]),
      FactoryBot.create(:high_score, arcade_machine: machines[1], game: games[0]),
      FactoryBot.create(:high_score, arcade_machine: machines[1], game: games[1]),

      FactoryBot.create(:high_score, arcade_machine: machines[1], game: games[0], sandbox: true),
      FactoryBot.create(:high_score, arcade_machine: machines[1], game: games[1], sandbox: true),

      FactoryBot.create(:high_score, arcade_machine: nil, game: games[0]),
      FactoryBot.create(:high_score, arcade_machine: nil, game: games[1])
    ]
  end

  it "returns all scores by default" do
    filtered = FilteredHighScores.new
    expect(filtered).to match_array scores
  end

  it "filters by game" do
    filtered = FilteredHighScores.new.game(games[0])
    expect(filtered).to match_array HighScore.where(game: games[0])
  end

  it "filters by sandbox" do
    filtered = FilteredHighScores.new.sandbox(true)
    expect(filtered).to match_array scores[4..5]
  end

  it "chains filters" do
    filtered = FilteredHighScores.new.arcade(machines[1]).game(games[0]).sandbox(true)
    expect(filtered).to match_array [scores[4]]
  end

  describe "filtering by arcade machine" do
    it "filters by object" do
      filtered = FilteredHighScores.new.arcade(machines[0])
      expect(filtered).to match_array scores[0..1]
    end

    it "filters by slug" do
      filtered = FilteredHighScores.new.arcade(machines[1].slug)
      expect(filtered).to match_array scores[2..5]
    end

    it "filters by api key" do
      filtered = FilteredHighScores.new.arcade(machines[1].api_keys.first.token)
      expect(filtered).to match_array scores[2..5]
    end

    it "filters by blank" do
      filtered = FilteredHighScores.new.arcade("none")
      expect(filtered).to match_array scores[6..7]
    end
  end

  describe "ordering" do
    it "highest->lowest by default" do
      filtered = FilteredHighScores.new
      expect(filtered.to_a).to eq HighScore.order(score: :desc).to_a
    end

    it "lowest->highest" do
      filtered = FilteredHighScores.new.order("low")
      expect(filtered.to_a).to eq HighScore.order(score: :asc).to_a
    end

    it "newest->oldest" do
      filtered = FilteredHighScores.new.order("new")
      expect(filtered.to_a).to eq HighScore.order(id: :desc).to_a
    end

    it "oldest->newest" do
      filtered = FilteredHighScores.new.order("old")
      expect(filtered.to_a).to eq HighScore.order(id: :asc).to_a
    end

    it "accepts arbitrary sorting" do
      filtered = FilteredHighScores.new.order(name: :asc)
      expect(filtered.to_a).to eq HighScore.order(name: :asc).to_a
    end

  end

end
