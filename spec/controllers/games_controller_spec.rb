require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "GET index" do
    it "assigns published games" do
      FactoryGirl.create_list(:game, 3)
      Game.last.update(published_at: nil)
      get :index
      expect(assigns(:theirs).count).to eq 2
      expect(assigns(:theirs)).to match_array Game.published
    end

    it "returns 200 OK" do
      get :index
      expect(response).to have_http_status :ok
    end
  end

  describe "GET show" do
    let (:game) { FactoryGirl.create(:game) }

    context "it exists" do
      it "assigns the game" do
        get :show, id: game.slug
        expect(assigns(:game)).to eq game
      end

      it "returns 200 OK" do
        get :show, id: game.slug
        expect(response).to have_http_status :ok
      end

      describe "json response" do
        it "doesn't panic without a zip file" do
          game.game_zips.destroy_all
          get :show, id: game.slug, format: "json"
          expect(response).to have_http_status :ok
        end
      end
    end

    context "it doesn't exist" do
      it "404's" do
        get :show, id: 321
        expect(response).to have_http_status 404
      end
    end

  end

  describe "GET new" do

    context "current user is admin" do
      before :each do
        sign_in admin
        get :new
      end

      it "returns 200 OK" do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe "GET edit" do
    let(:game) { FactoryGirl.create(:game) }

    context "current user is admin" do
      before :each do
        sign_in admin
        get :edit, id: game.slug
      end

      it "returns 200 OK" do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe "POST create" do
    let(:attributes) do
      {
        title: "Great",
        description: "Okay",
        zipfile_key: "ok.zip"
      }
    end

    context "valid attributes" do
      before :each do
        sign_in admin
      end

      it "saves the Game" do
        expect {
          post :create, game: attributes
        }.to change(Game, :count).by 1
      end

    end

    context "bad attributes" do
      before :each do
        sign_in admin
      end

      it "does not save the game" do
        expect {
          post :create, game: {}
        }.to_not change(Game, :count)
      end

      it "renders new" do
        post :create, game: {}
        expect(response).to render_template(:new)
      end

    end
  end

  describe "PUT update" do
    let(:game) { FactoryGirl.create(:game) }

    let(:attributes) do
      {
        title: "Great"
      }
    end

    context "admin user" do
      before :each do
        sign_in admin
      end

      context "valid attributes" do
        it "saves the Game" do
          put :update, { id: game.slug, game: attributes }
          expect(game.reload.title).to eq attributes[:title]
        end
      end

      context "bad attributes" do

        it "does not save the game" do
          put :update, { id: game.slug, game: { title: "" } }
          expect(Game.find_by(slug: game.slug).title).to eq game.title
        end

        it "renders edit" do
          put :update, { id: game.slug, game: { title: "" } }
          expect(response).to render_template(:edit)
        end

      end
    end
  end

  describe "DELETE destroy" do
    let(:game) { FactoryGirl.create(:game) }

    context "non-owner" do
      before :each do
        sign_in FactoryGirl.create(:user)
      end

      it "does not delete the game" do
        delete :destroy, id: game.slug
        expect(Game.find_by(slug: game.slug)).to eq game
      end

      it "returns 403" do
        delete :destroy, id: game.slug
        expect(response).to have_http_status 403
      end
    end

    context "owner" do
      before :each do
        sign_in game.users.first
      end

      it "deletes the game" do
        delete :destroy, id: game.slug
        expect(Game.where(id: game.slug).count).to eq 0
      end
    end

    context "admin user" do
      before :each do
        sign_in admin
      end

      it "deletes the game" do
        delete :destroy, id: game.slug
        expect(Game.where(id: game.slug).count).to eq 0
      end
    end

  end
end
