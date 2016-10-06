require 'rails_helper'

RSpec.describe ArcadeMachinesController, type: :controller do
  describe "GET index" do
    it_behaves_like "simple GET action", :index
  end

  describe "GET show" do
    it_behaves_like "simple GET action", :show, { id: FactoryGirl.create(:arcade_machine).id }
  end

  describe "GET new" do

    it_behaves_like "requires sign in", :new

    context "user is logged in" do
      let(:user) { FactoryGirl.create(:user) }

      before :each do
        sign_in user
      end

      it_behaves_like "simple GET action", :new
    end

  end

  describe "GET edit" do
    it_behaves_like "requires sign in", :edit, { id: FactoryGirl.create(:arcade_machine).id }

    context "user is signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before :each do
        sign_in user
      end

      context "user owns the arcade_machine" do
        let(:arcade_machine) { FactoryGirl.create(:arcade_machine, users: [user]) }
        let(:params) { { id: arcade_machine.id } }

        it_behaves_like "simple GET action", :edit
      end

      context "user does not own the arcade_machine" do
        context "user is admin" do
          let(:user) { FactoryGirl.create(:admin) }

          let(:arcade_machine) { FactoryGirl.create(:arcade_machine) }
          let(:params) { { id: arcade_machine.id } }

          it_behaves_like "simple GET action", :edit
        end

        context "user is not admin" do
          let(:arcade_machine) { FactoryGirl.create(:arcade_machine) }

          it "responds 403" do
            get :edit, id: arcade_machine.id
            expect(response).to have_http_status :forbidden
          end
        end
      end
    end
  end

  describe "POST create" do
    let(:attributes) do
      {
        name: "The Incredible Machine"
      }
    end

    let(:user) { FactoryGirl.create(:user) }

    it "requires sign in"

    context "valid attributes" do
      before :each do
        sign_in user
      end

      it "saves the arcade_machine" do
        expect {
          post :create, arcade_machine: attributes
        }.to change(ArcadeMachine, :count).by 1
      end

      it "assins ownership to the logged-in user" do
        post :create, arcade_machine: attributes
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
          post :create, arcade_machine: bad_attrs
        }.to_not change(ArcadeMachine, :count)
      end

      it "renders new" do
        post :create, arcade_machine: bad_attrs
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do
    let(:arcade_machine) { FactoryGirl.create(:arcade_machine) }

    let(:attributes) do
      {
        name: "T-1000"
      }
    end

    it "requires sign in"

    context "signed-in" do

      context "user is admin or owns the arcade_machine" do

        let(:admin) { FactoryGirl.create(:admin) }
        let(:owner) { arcade_machine.users.first }

        context "valid attributes" do
          it "saves the arcade_machine" do
            [admin, owner].each do |user|
              sign_in user

              put :update, { id: arcade_machine.id, arcade_machine: attributes }
              expect(arcade_machine.reload.name).to eq attributes[:name]
            end
          end
        end

      end

      context "user does not own the arcade_machine" do
        let(:user) { FactoryGirl.create(:user) }

        before :each do
          sign_in user
        end

        it "responds 403" do
          put :update, { id: arcade_machine.id, arcade_machine: attributes }
          expect(response).to have_http_status :forbidden
        end
      end


      context "bad attributes" do
        before :each do
          sign_in arcade_machine.users.first
        end

        it "does not save the arcade_machine" do
          put :update, { id: arcade_machine.id, arcade_machine: { name: "" } }
          expect(ArcadeMachine.find(arcade_machine.id).name).to eq arcade_machine.name
        end

        it "renders edit" do
          put :update, { id: arcade_machine.id, arcade_machine: { name: "" } }
          expect(response).to render_template(:edit)
        end

      end

    end
  end

  describe "DELETE destroy" do
    let!(:arcade_machine) { FactoryGirl.create(:arcade_machine) }


    it "requires sign in"

    context "signed in" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:owner) { arcade_machine.users.first }

      before :each do
        sign_in user
      end

      context "user is admin" do
        let(:user) { admin }

        it "redirects to arcade_machine index" do
          delete :destroy, id: arcade_machine.id
          expect(response).to redirect_to(arcade_machines_path)
        end

        it "removes the arcade_machine" do
          delete :destroy, id: arcade_machine.id
          expect {
            ArcadeMachine.find(arcade_machine.id)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

      context "user is owner" do
        let(:user) { owner }

        it "redirects to arcade_machine index" do
          delete :destroy, id: arcade_machine.id
          expect(response).to redirect_to(arcade_machines_path)
        end

        it "removes the arcade_machine" do
          delete :destroy, id: arcade_machine.id
          expect {
            ArcadeMachine.find(arcade_machine.id)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is not owner" do
        let(:user) { FactoryGirl.create(:user) }

        it "does not remove the arcade_machine" do
          expect {
            delete :destroy, id: arcade_machine.id
          }.to_not change(ArcadeMachine, :count)
        end
      end
    end

  end


end