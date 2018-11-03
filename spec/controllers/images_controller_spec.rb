require "rails_helper"

RSpec.describe ImagesController, type: :controller do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:parent) { FactoryBot.create(:game) }
  let(:owner) { parent.users.first }

  let(:params) do
    {
      parent_type: parent.class.name,
      parent_id: parent.id,
      filename: "screenshot.jpg",
      lastModifiedDate: Time.now
    }
  end

  describe "POST create" do
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

    it "creates the image" do
      sign_in owner
      post :create, params: params
      expect(parent.images.first.file_key).to eq "games/#{parent.id}-image-screenshot.jpg"
    end
  end

  describe "DELETE destroy" do
    let!(:image) { FactoryBot.create(:image, parent: parent) }
    let(:params) do
      {
        id: image.id,
        parent_type: parent.class.name,
        parent_id: parent.id
      }
    end

    it "allows owners" do
      sign_in owner
      delete :destroy, params: params
      expect(response).to have_http_status(:found)
    end

    it "disallows non-owners" do
      sign_in FactoryBot.create(:user)
      delete :destroy, params: params
      expect(response).to have_http_status(:forbidden)
    end

    it "deletes the image" do
      sign_in owner
      delete :destroy, params: params
      expect(parent.images.reload.all?(&:placeholder?)).to eq true
    end
  end
end