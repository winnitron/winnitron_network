require 'rails_helper'

RSpec.describe Api::V1::PlaylistsController, type: :controller do
  let(:winnitron) { FactoryGirl.create(:arcade_machine) }
  let(:token) { winnitron.api_keys.first.token }
  let(:playlists) { FactoryGirl.create_list(:playlist, 3) }
  let(:games) { FactoryGirl.create_list(:game, 5) }

  before :each do
    allow_any_instance_of(Game).to receive(:download_url).and_return("http://example.com/game.zip")
    allow_any_instance_of(Image).to receive(:url).and_return("http://example.com/screenshot.png")
  end

  describe "GET index" do
    render_views

    let(:playlist_hash) do
      {
        "playlists" => winnitron.playlists.map do |playlist|
          {
            "title" => playlist.title,
            "slug"  => playlist.title.parameterize,
            "games" => playlist.games.with_zip.map do |game|
              {
                "title"           => game.title,
                "slug"            => game.title.parameterize,
                "min_players"     => game.min_players,
                "max_players"     => game.max_players,
                "description"     => game.description,
                "legacy_controls" => game.legacy_controls,
                "download_url"    => game.download_url,
                "last_modified"   => game.current_zip.file_last_modified.iso8601,
                "executable"      => game.current_zip.executable,
                "image_url"       => game.cover_image.url,
                "keys"            => { "template" => game.key_map.template }
              }
            end
          }
        end
      }
    end


    include_examples "disallows bad API keys", :get, :index

    it "accepts API key in params" do
      get :index, { api_key: token, format: "json" }
      expect(response).to have_http_status(:ok)
    end

    it "accepts API key in headers" do
      request.headers["Authorization"] = "Token #{token}"
      get :index, { format: "json" }
      expect(response).to have_http_status(:ok)
    end

    describe "with subscriptions" do
      before :each do
        playlists.each do |playlist|
          games.sample(2).each { |g| playlist.listings.create(game: g) }
          winnitron.subscriptions.create playlist: playlist
        end
      end

      it "returns the machine's playlists" do
        get :index, { api_key: token, format: "json" }
        expect(JSON.parse(response.body)["playlists"]).to match_array playlist_hash["playlists"]
      end

      it "does not list games without zip files" do
        no_zip = FactoryGirl.create(:game)
        no_zip.game_zips.destroy_all
        Listing.create!(game: no_zip, playlist: winnitron.playlists.first)

        get :index, { api_key: token, format: "json" }
        game_titles = JSON.parse(response.body)["playlists"][0]["games"].map { |g| g["title"] }
        expect(game_titles).to_not include(no_zip.title)
      end
    end
  end

end