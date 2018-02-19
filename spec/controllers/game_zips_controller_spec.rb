require "rails_helper"

RSpec.describe GameZipsController, type: :controller do
  let(:admin) { FactoryBot.create(:admin) }
  let(:game) { FactoryBot.create(:game) }
  let(:owner) { game.users.first }


  describe "POST create" do
    let(:params) do
      {
        game_id: game.id,
        filepath: "/games/#{game.id}-123-greatgame.zip",
        lastModifiedDate: Time.now
      }
    end

    it "allows owners" do
      sign_in owner
      post :create, params: params
      expect(response).to have_http_status(:created)
    end

    it "disallows non-owners" do
      sign_in FactoryBot.create(:user)
      post :create, params: params
      expect(response).to have_http_status(:forbidden)
    end

    it "creates the zip" do
      sign_in owner
      expect {
        post :create, params: params
      }.to change { game.game_zips.count }.by(1)
    end

  end
end