require 'rails_helper'

RSpec.describe Api::V1::PlaysController, type: :controller do
  let(:winnitron) { FactoryBot.create(:arcade_machine) }
  let(:token) { winnitron.api_keys.first.token }
  let(:game) { FactoryBot.create(:game) }

  describe "POST create" do
    render_views

    include_examples "disallows bad API keys", :post, :create

    it "creates Play" do
      expect {
        post :create, params: { game: game.slug, api_key: token, start: 1.hour.ago, stop: Time.now }
      }.to change { Play.count }.by(1)
    end

    it "renders Play" do
      post :create, params: { game: game.slug, start: 1.hour.ago, stop: Time.now, api_key: token }

      play = JSON.parse(response.body).symbolize_keys
      expected = {
        arcade_machine_id: winnitron.id,
        game_id: game.id
      }

      expect(play.slice(:arcade_machine_id, :game_id)).to eq expected
      expect(play[:start]).to_not be nil
      expect(play[:stop]).to_not be nil
    end

    it "renders errors" do
      post :create, params: { api_key: token, start: 1.hour.ago }

      errors = JSON.parse(response.body)["errors"]
      expect(errors).to eq ["Game can't be blank"]
    end
  end

  describe "POST start" do
    render_views

    include_examples "disallows bad API keys", :post, :start

    it "creates Play" do
      expect {
        post :start, params: { game: game.slug, api_key: token }
      }.to change { Play.count }.by(1)
    end

    it "renders Play" do
      post :start, params: { game: game.slug, api_key: token }

      play = JSON.parse(response.body).symbolize_keys
      expected = {
        arcade_machine_id: winnitron.id,
        game_id: game.id
      }

      expect(play.slice(:arcade_machine_id, :game_id)).to eq expected
      expect(play[:start]).to_not be nil
    end

    it "renders errors" do
      post :start, params: { api_key: token }

      errors = JSON.parse(response.body)["errors"]
      expect(errors).to eq ["Game can't be blank"]
    end
  end

  describe "PUT update" do
    let!(:play) do
      Play.create(game: game, arcade_machine: winnitron, start: 2.minutes.ago.utc)
    end

    include_examples "disallows bad API keys", :put, :stop do
      let(:params) do
        { id: play.id }
      end
    end

    it "adds stop time" do
      put :stop, params: { id: game.slug, api_key: token }
      expect(play.reload.stop).to_not be nil
    end

    it "renders play" do
      put :stop, params: { id: game.slug, api_key: token }

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
      put :stop, params: { id: "fake", api_key: token }
      expect(response).to have_http_status :not_found
    end

    it "404s for mismatched arcade machine" do
      play.update stop: Time.now.utc
      someone_else = FactoryBot.create(:arcade_machine)
      other_play = Play.create(game: game, arcade_machine: someone_else, start: Time.now.utc)

      put :stop, params: { id: game.slug, api_key: token }
      expect(response).to have_http_status :not_found
    end

  end
end