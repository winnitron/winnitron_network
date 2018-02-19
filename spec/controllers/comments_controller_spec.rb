require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:game) { FactoryBot.create(:game) }

  let(:admin) { FactoryBot.create(:admin) }
  let(:dev) { game.users.first }
  let(:builder) { FactoryBot.create(:builder) }
  let(:joeshmoe) { FactoryBot.create(:user) }

  let(:valid_attrs) do
    {
      parent_id: game.id,
      comment: { comment: "I have many opinions" }
    }
  end

  describe "POST create" do
    context "user is allowed to comment" do
      before :each do
        sign_in admin
      end

      it "creates the comment" do
        expect {
          post :create, params: valid_attrs
        }.to change { Comment.count }.by(1)

        expected = {
          comment: valid_attrs[:comment][:comment],
          user_id: admin.id,
          commentable: game
        }
        expect(Comment.last.slice(*expected.keys)).to eq expected.stringify_keys
      end
    end

    it "allows builders" do
      sign_in builder
      post :create, params: valid_attrs
      expect(response).to have_http_status :created
    end

    it "allows game owner" do
      sign_in dev
      post :create, params: valid_attrs
      expect(response).to have_http_status :created
    end

    it "does not allow other users" do
      sign_in joeshmoe
      post :create, params: valid_attrs
      expect(response).to have_http_status :forbidden
    end
  end
end
