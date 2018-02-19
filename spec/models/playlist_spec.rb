require "rails_helper"

RSpec.describe Playlist, type: :model do
  describe "smart updates" do

    context "it's not smart" do
      let(:playlist) { Playlist.new(title: "Dumb", user: FactoryBot.build(:user)) }

      it "does shit all" do
        playlist.save
        expect(playlist.listings).to be_empty
      end
    end

    context "it's smart" do
      let(:playlist) do
        p = Playlist.new(title: "Dumb", user: FactoryBot.build(:user))
        p.smart_tag_list = "good, bad, ugly"
        p
      end

      let!(:matching) do
        games = FactoryBot.create_list(:game, 3)
        games.each do |game|
          game.tag_list = ["good", "bad", "ugly", Faker::Lorem.word].join(",")
          game.save
        end

        games
      end

      let!(:non_matching) do
        g = FactoryBot.create(:game)
        g.tag_list = "good, foo, bar"
        g
      end

      it "creates listings for all matching games" do
        playlist.save
        expect(playlist.games).to match_array matching
      end

      it "does not include non-matching games" do
        playlist.save
        expect(playlist.games).to_not include(non_matching)
      end
    end

  end
end