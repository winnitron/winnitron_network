require 'rails_helper'

RSpec.describe AttractsController, type: :controller do
  let(:machine) { FactoryBot.create(:arcade_machine) }
  let(:owner) { machine.users.first }

  describe "GET new" do
    it_behaves_like "requires sign in", :new

    it "renders" do
      sign_in owner
      get :new
      expect(response).to have_http_status :ok
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        arcade_machine_id: machine.id,
        starts_at: Date.yesterday.iso8601,
        ends_at: Date.tomorrow.iso8601,
        text: Faker::Lorem.sentence
      }
    end
  end
end
