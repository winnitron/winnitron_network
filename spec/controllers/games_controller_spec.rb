require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "GET index" do
    before :each do
      get :index
    end

    it "assigns all games" do
      FactoryGirl.create_list(:game, 2)
      expect(assigns(:games)).to eq Game.all
    end

    it "returns 200 OK" do
      expect(response).to have_http_status :ok
    end
  end

  describe "GET show" do
    let (:game) { FactoryGirl.create(:game) }

    context "it exists" do
      before :each do
        get :show, id: game.id
      end

      it "assigns the game" do
        expect(assigns(:game)).to eq game
      end

      it "returns 200 OK" do
        expect(response).to have_http_status :ok
      end
    end

    context "it doesn't exist" do
      it "404's" do
        expect {
          get :show, id: 321
        }.to raise_error(ActiveRecord::RecordNotFound)
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
        get :edit, id: game.id
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
        s3_key: "ok.zip"
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
          put :update, { id: game.id, game: attributes }
          expect(game.reload.title).to eq attributes[:title]
        end
      end

      context "bad attributes" do

        it "does not save the game" do
          put :update, { id: game.id, game: { title: "" } }
          expect(Game.find(game.id).title).to eq game.title
        end

        it "renders edit" do
          put :update, { id: game.id, game: { title: "" } }
          expect(response).to render_template(:edit)
        end

      end
    end
  end

  describe "DELETE destroy" do
    let (:game) { FactoryGirl.create(:game) }

    context "non-owner" do
      pending
    end

    context "admin user" do
      before :each do
        sign_in admin
      end

      it "deletes the game" do
        delete :destroy, id: game.id
        expect(Game.where(id: game.id).count).to eq 0
      end
    end

  end


end
