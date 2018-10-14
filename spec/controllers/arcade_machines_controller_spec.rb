require 'rails_helper'

RSpec.describe ArcadeMachinesController, type: :controller do
  describe "GET index" do
    it_behaves_like "simple GET action", :index

    it "only shows approved arcade machines" do
      machines = FactoryBot.create_list(:arcade_machine, 3)
      machines.last.approval_request.destroy
      get :index
      expect(assigns(:theirs).map(&:id)).to match_array machines.first(2).map(&:id)
    end

    it "shows all of your own machines even if they're unapproved"
  end

  describe "GET show" do
    it_behaves_like "simple GET action", :show do
      let(:params) do
        { id: FactoryBot.create(:arcade_machine).slug }
      end
    end

    context "machine isn't approved" do
      context "there is no approval request" do
        let(:machine) do
          machine = FactoryBot.create(:arcade_machine)
          machine.approval_request.destroy
          machine.reload
        end

        it "fails if not signed in" do
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :forbidden
        end

        it "fails if not owner" do
          sign_in FactoryBot.create(:user)
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :forbidden
        end

        it "succeeds for owner" do
          sign_in machine.users.first
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :ok
        end

        it "succeeds for admin" do
          sign_in FactoryBot.create(:admin)
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :ok
        end
      end

      context "there is a pending approval request" do
        let(:machine) do
          machine = FactoryBot.create(:arcade_machine)
          machine.approval_request.update(approved_at: nil)
          machine.reload
        end

        it "fails if not signed in" do
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :forbidden
        end

        it "fails if not owner" do
          sign_in FactoryBot.create(:user)
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :forbidden
        end

        it "succeeds for owner" do
          sign_in machine.users.first
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :ok
        end

        it "succeeds for admin" do
          sign_in FactoryBot.create(:admin)
          get :show, params: { id: machine.slug }
          expect(response).to have_http_status :ok
        end
      end
    end
  end

  describe "GET new" do

    it_behaves_like "requires sign in", :new

    context "user is a builder" do
      let(:user) { FactoryBot.create(:builder) }

      before :each do
        sign_in user
      end

      it_behaves_like "simple GET action", :new
    end
  end

  describe "GET edit" do
    it_behaves_like "requires sign in", :edit do
      let(:params) do
        { id: FactoryBot.create(:arcade_machine).slug }
      end
    end

    context "user is a builder" do
      let(:user) { FactoryBot.create(:builder) }

      before :each do
        sign_in user
      end

      context "user owns the arcade_machine" do
        let(:arcade_machine) { FactoryBot.create(:arcade_machine, users: [user]) }
        let(:params) { { id: arcade_machine.slug } }

        it_behaves_like "simple GET action", :edit
      end

      context "user does not own the arcade_machine" do
        context "user is admin" do
          let(:user) { FactoryBot.create(:admin) }

          let(:arcade_machine) { FactoryBot.create(:arcade_machine) }
          let(:params) { { id: arcade_machine.slug } }

          it_behaves_like "simple GET action", :edit
        end

        context "user is not admin" do
          let(:arcade_machine) { FactoryBot.create(:arcade_machine) }

          it "responds 403" do
            get :edit, params: { id: arcade_machine.slug }
            expect(response).to have_http_status :forbidden
          end
        end
      end
    end
  end

  describe "POST create" do
    let(:attributes) do
      {
        title: "The Incredible Machine",
        players: 2,
        location_attributes: {
          city: "Luna"
        }
      }
    end

    let(:user) { FactoryBot.create(:builder) }

    it "requires sign in"

    context "valid attributes" do
      before :each do
        sign_in user
      end

      it "saves the arcade_machine" do
        expect {
          post :create, params: { arcade_machine: attributes }
        }.to change(ArcadeMachine, :count).by 1
      end

      it "assigns ownership to the logged-in user" do
        post :create, params: { arcade_machine: attributes }
        expect(ArcadeMachine.last.users).to include(user)
      end
    end

    context "bad attributes" do
      let(:bad_attrs) { { garbage_in: "garbage out" } }
      before :each do
        sign_in user
      end

      it "does not save the arcade_machine" do
         expect {
          post :create, params: { arcade_machine: bad_attrs }
        }.to_not change(ArcadeMachine, :count)
      end

      it "renders new" do
        post :create, params: { arcade_machine: bad_attrs }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do
    let(:arcade_machine) { FactoryBot.create(:arcade_machine) }

    let(:attributes) do
      {
        title: "T-1000"
      }
    end

    it "requires sign in"

    context "signed-in" do

      context "user is admin or owns the arcade_machine" do

        let(:admin) { FactoryBot.create(:admin) }
        let(:owner) { arcade_machine.users.first }

        context "valid attributes" do
          it "saves the arcade_machine" do
            [admin, owner].each do |user|
              sign_in user

              put :update, params: { id: arcade_machine.slug, arcade_machine: attributes }
              expect(arcade_machine.reload.title).to eq attributes[:title]
            end
          end
        end

      end

      context "user does not own the arcade_machine" do
        let(:user) { FactoryBot.create(:user) }

        before :each do
          sign_in user
        end

        it "redirects to request-builder page" do
          put :update, params: { id: arcade_machine.slug, arcade_machine: attributes }
          expect(response).to have_http_status :forbidden
        end
      end


      context "bad attributes" do
        before :each do
          sign_in arcade_machine.users.first
        end

        it "does not save the arcade_machine" do
          put :update, params: { id: arcade_machine.slug, arcade_machine: { title: "" } }
          arc = ArcadeMachine.find_by(slug: arcade_machine.slug)
          expect(arc.title).to eq arcade_machine.title
        end

        it "renders edit" do
          put :update, params: { id: arcade_machine.slug, arcade_machine: { title: "" } }
          expect(response).to render_template(:edit)
        end

      end

    end
  end

  describe "DELETE destroy" do
    let!(:arcade_machine) { FactoryBot.create(:arcade_machine) }

    it "requires sign in"

    context "signed in" do
      let(:admin) { FactoryBot.create(:admin) }
      let(:owner) { arcade_machine.users.first }

      before :each do
        sign_in user
      end

      context "user is admin" do
        let(:user) { admin }

        it "redirects to arcade_machine index" do
          delete :destroy, params: { id: arcade_machine.slug }
          expect(response).to redirect_to(arcade_machines_path)
        end

        it "removes the arcade_machine" do
          delete :destroy, params: { id: arcade_machine.slug }
          expect {
            ArcadeMachine.find(arcade_machine.slug)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

      context "user is owner" do
        let(:user) { owner }

        it "redirects to arcade_machine index" do
          delete :destroy, params: { id: arcade_machine.slug }
          expect(response).to redirect_to(arcade_machines_path)
        end

        it "removes the arcade_machine" do
          delete :destroy, params: { id: arcade_machine.slug }
          expect {
            ArcadeMachine.find(arcade_machine.slug)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is not owner" do
        let(:user) { FactoryBot.create(:user) }

        it "does not remove the arcade_machine" do
          expect {
            delete :destroy, params: { id: arcade_machine.slug }
          }.to_not change(ArcadeMachine, :count)
        end
      end
    end

  end


end