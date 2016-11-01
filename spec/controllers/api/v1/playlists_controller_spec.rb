require 'rails_helper'

RSpec.describe Api::V1::PlaylistsController, type: :controller do
  let(:winnitron) { FactoryGirl.create(:arcade_machine) }
  let(:token) { winnitron.api_keys.first.token }
  let(:playlists) { FactoryGirl.create_list(:playlist, 3) }
  let(:games) { FactoryGirl.create_list(:game, 5) }

  describe "GET index" do
    render_views

    let(:playlist_hash) do
      {
        "playlists" => winnitron.playlists.map do |playlist|
          {
            "title" => playlist.title,
            "slug"  => playlist.title.parameterize,
            "games" => playlist.games.map do |game|
              {
                "title"         => game.title,
                "slug"          => game.title.parameterize,
                "min_players"   => game.min_players,
                "max_players"   => game.max_players,
                "description"   => game.description,
                "download_url"  => game.download_url,
                "last_modified" => game.current_zip.file_last_modified.iso8601
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

    it "returns the machine's playlists" do
      playlists.each do |playlist|
        games.sample(2).each { |g| playlist.listings.create game: g }
        winnitron.subscriptions.create playlist: playlist
      end

      get :index, { api_key: token, format: "json" }

      expect(JSON.parse(response.body)).to eq playlist_hash
    end
  end

end