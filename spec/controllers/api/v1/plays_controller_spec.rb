require 'rails_helper'

RSpec.describe Api::V1::PlaysController, type: :controller do
  let(:winnitron) { FactoryGirl.create(:arcade_machine) }
  let(:token) { winnitron.api_keys.first.token }
  let(:game) { FactoryGirl.create(:game) }

  describe "POST start" do
    render_views

    include_examples "disallows bad API keys", :post, :start

    it "creates Play" do
      expect {
        post :start, { game: game.slug, api_key: token }
      }.to change { Play.count }.by(1)
    end

    it "renders Play" do
      post :start, { game: game.slug, api_key: token }

      play = JSON.parse(response.body).symbolize_keys
      expected = {
        arcade_machine_id: winnitron.id,
        game_id: game.id
      }

      expect(play.slice(:arcade_machine_id, :game_id)).to eq expected
      expect(play[:start]).to_not be nil
    end

    it "renders errors" do
      post :start, { api_key: token }

      errors = JSON.parse(response.body)["errors"]
      expect(errors).to eq ["Game can't be blank"]
    end
  end

  describe "PUT update" do
    let(:play) do
      Play.create(game: game, arcade_machine: winnitron, start: 2.minutes.ago.utc)
    end

    include_examples "disallows bad API keys", :put, :stop do
      let(:params) do
        { id: play.id }
      end
    end

    it "adds stop time" do
      put :stop, { id: play.id, api_key: token }
      expect(play.reload.stop).to_not be nil
    end

    it "renders play" do
      put :stop, { id: play.id, api_key: token }

      rendered = JSON.parse(response.body).symbolize_keys
      expected = {
        arcade_machine_id: winnitron.id,
        game_id: game.id
      }

      expect(rendered.slice(:arcade_machine_id, :game_id)).to eq expected
      expect(rendered[:start]).to_not be nil
      expect(rendered[:stop]).to_not be nil
    end

    it "404s for nonexistent Play" do
      put :stop, { id: 54321, api_key: token }
      expect(response).to have_http_status :not_found
    end

    it "404s for mismatched arcade machine" do
      someone_else = FactoryGirl.create(:arcade_machine)
      other_play = Play.create(game: game, arcade_machine: someone_else, start: Time.now.utc)

      put :stop, { id: other_play.id, api_key: token }
      expect(response).to have_http_status :not_found
    end

  end
end