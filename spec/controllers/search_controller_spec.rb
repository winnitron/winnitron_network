require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  context 'GET search' do
    let!(:game) { FactoryBot.create(:game, title: 'Game 1') }

    it 'get the games that match the kw' do
      get :index, params: { kw: 'game' }

      expect(response).to have_http_status(:ok)
    end

    it 'handle the request even without the kw param' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
