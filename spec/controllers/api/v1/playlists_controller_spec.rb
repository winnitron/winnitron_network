require 'rails_helper'

RSpec.describe Api::V1::PlaylistsController, type: :controller do
  let(:winnitron) { FactoryBot.create(:arcade_machine) }
  let(:token) { winnitron.api_keys.first.token }
  let(:playlists) { FactoryBot.create_list(:playlist, 3) }
  let(:games) { FactoryBot.create_list(:game, 5) }

  before :each do
    allow_any_instance_of(Game).to receive(:download_url).and_return("http://example.com/game.zip")
    allow_any_instance_of(Image).to receive(:url).and_return("http://example.com/screenshot.png")

    playlists.first.update(default: true)
  end

  def playlist_hash(playlist)
    {
      "title" => playlist.title,
      "description" => playlist.description,
      "slug"  => playlist.title.parameterize,
      "games" => playlist.games.published.map do |game|
        {
          "title"           => game.title,
          "slug"            => game.title.parameterize,
          "min_players"     => game.min_players,
          "max_players"     => game.max_players,
          "description"     => game.description,
          "legacy_controls" => game.key_map.template == "legacy",
          "download_url"    => game.download_url,
          "last_modified"   => game.current_zip.created_at.iso8601,
          "executable"      => game.current_zip.executable,
          "image_url"       => game.cover_image.url,
          "keys"            => {
                                 "template" => game.key_map.template,
                                 "bindings" => game.key_map.bindings
                               }
        }
      end
    }
  end

  describe "GET index" do
    render_views

    let(:playlists_hash) do
      {
        "playlists" => winnitron.playlists.map { |p| playlist_hash(p) }
      }
    end

    include_examples "disallows bad API keys", :get, :index

    it "accepts API key in params" do
      get :index, params: { api_key: token, format: "json" }
      expect(response).to have_http_status(:ok)
    end

    it "accepts API key in headers" do
      request.headers["Authorization"] = "Token #{token}"
      get :index, { format: "json" }
      expect(response).to have_http_status(:ok)
    end

    it "saves request" do
      get :index, params: { api_key: token, format: "json" }
      event = LoggedEvent.last
      expect(event.actor).to eq winnitron
      expect(event.details).to eq({ "user_agent" => "Rails Testing" })
    end

    describe "with subscriptions" do
      before :each do
        playlists.each do |playlist|
          games.sample(2).each { |g| playlist.listings.create(game: g) }
          winnitron.subscriptions.create playlist: playlist
        end
      end

      context "approved machine" do
        it "returns the machine's playlists" do
          get :index, params: { api_key: token, format: "json" }
          actual = JSON.parse(response.body)["playlists"]
          expected = playlists_hash["playlists"]
          expect(actual).to match_array expected
        end

        it "does not list unpublished games" do
          unpublished = FactoryBot.create(:game)
          unpublished.update(published_at: nil)
          Listing.create!(game: unpublished, playlist: winnitron.playlists.first)

          get :index, params: { api_key: token, format: "json" }
          game_titles = JSON.parse(response.body)["playlists"][0]["games"].map { |g| g["title"] }
          expect(game_titles).to_not include(unpublished.title)
        end
      end

      context "unapproved machine" do
        it "only returns default playlists" do
          winnitron.approval_request.update approved_at: nil

          get :index, params: { api_key: token, format: "json" }
          actual = JSON.parse(response.body)["playlists"]
          expected = [playlist_hash(playlists.first)]

          expect(actual).to match_array expected
        end
      end
    end
  end

end