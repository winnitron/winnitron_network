require "rails_helper"

RSpec.describe Api::V1::HighScoresController, type: :controller do
  let(:game) { FactoryBot.create(:game) }
  let(:game_key) { game.api_keys.first }
  let(:machine) { FactoryBot.create(:arcade_machine) }
  let(:am_key) { machine.api_keys.first }

  def sig(params)
    Digest::SHA256.hexdigest(params.except(:api_key).to_query + game_key.secret)
  end

  describe "GET index" do
    let(:auth) do
      { api_key: game_key.token }
    end

    it "returns 200 OK" do
      get :index, params: auth
      expect(response).to have_http_status :ok
    end

    it "limits" do
      FactoryBot.create_list(:high_score, 5, game: game)

      get :index, params: auth.merge(limit: 2)
      body = JSON.parse(response.body)["high_scores"]
      expect(body.count).to eq 2
    end

    it "scopes by arcade machine" do
      mach1 = FactoryBot.create_list(:high_score, 3, game: game, arcade_machine: machine)
      others = FactoryBot.create_list(:high_score, 4, game: game)

      get :index, params: auth.merge(winnitron_id: machine.slug)
      body = JSON.parse(response.body)["high_scores"]
      expect(body.count).to eq 3
      expect(body.map { |hs| hs["arcade_machine"] }.uniq).to eq [machine.slug]
    end

    describe "sandbox" do
      let!(:real) { FactoryBot.create_list(:high_score, 2, game: game) }
      let!(:fake) { FactoryBot.create_list(:high_score, 2, game: game, sandbox: true) }

      it "returns non-sandbox scores by default" do
        get :index, params: auth
        body = JSON.parse(response.body)["high_scores"]
        expect(body).to match_array(real.sort_by(&:score).reverse.as_json)
      end

      it "returns non-sandbox scores if given test=0 for some reason" do
        get :index, params: auth.merge(test: 0)
        body = JSON.parse(response.body)["high_scores"]
        expect(body).to match_array(real.sort_by(&:score).reverse.as_json)
      end

      it "returns only sandbox scores if given test=1" do
        get :index, params: auth.merge(test: 1)
        body = JSON.parse(response.body)["high_scores"]
        expect(body).to match_array(fake.sort_by(&:score).reverse.as_json)
      end

      it "returns only sandbox scores if given test=like_anything_yeesh" do
        get :index, params: auth.merge(test: "like_anything_yeesh")
        body = JSON.parse(response.body)["high_scores"]
        expect(body).to match_array(fake.sort_by(&:score).reverse.as_json)
      end
    end
  end

  describe "POST create" do

    context "supplying winnitron_id by api key" do
      let(:unsigned) do
        {
          api_key: game_key.token,
          name: Faker::Name.first_name,
          score: rand(1000),
          winnitron_id: am_key.token
        }
      end
      let(:params) { unsigned.merge(sig: sig(unsigned)) }

      it "responds 201 Created" do
        post :create, params: params
        expect(response).to have_http_status :created
      end

      it "creates a high score with correct ArcadeMachine" do
        expect {
          post :create, params: params
        }.to change { HighScore.count }.by(1)
        expect(HighScore.last.arcade_machine).to eq machine
      end

      it "errors if machine not found" do
        unsigned = {
          api_key: game_key.token,
          name: Faker::Name.first_name,
          score: rand(1000),
          winnitron_id: "WHO KNOWS"
        }
        params = unsigned.merge(sig: sig(unsigned))

        expect {
          post :create, params: params
        }.to_not change { HighScore.count }

        error = JSON.parse(response.body)["errors"].first
        expect(error).to include("Could not find Winnitron")
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context "no winnitron_id" do
      let(:unsigned) do
        {
          api_key: game_key.token,
          name: Faker::Name.first_name,
          score: rand(1000)
        }
      end
      let(:params) { unsigned.merge(sig: sig(unsigned)) }

      it "responds 201 Created" do
        post :create, params: params
        expect(response).to have_http_status :created
      end

      it "creates a high score with blank ArcadeMachine" do
        expect {
          post :create, params: params
        }.to change { HighScore.count }.by(1)
        expect(HighScore.last.arcade_machine).to be_nil
      end

    end

    describe "sandbox" do
      let(:unsigned) do
        {
          api_key: game_key.token,
          name: Faker::Name.first_name,
          score: rand(1000),
          winnitron_id: am_key.token
        }
      end
      let(:params) { unsigned.merge(sig: sig(unsigned)) }

      it "creates a sandbox high score if given test=whatever" do
        post :create, params: params.merge(test: "something")
        hs = HighScore.last
        expect(hs.sandbox?).to eq true
      end

      it "creates a real high score by default" do
        post :create, params: params
        hs = HighScore.last
        expect(hs.sandbox?).to eq false
      end

      it "creates a real high score if given test=0" do
        post :create, params: params.merge(test: 0)
        hs = HighScore.last
        expect(hs.sandbox?).to eq false
      end
    end
  end
end
