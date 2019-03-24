require "rails_helper"

RSpec.describe Api::V1::AttractsController, type: :controller do
  let(:machine) { FactoryBot.create(:arcade_machine) }
  let(:am_key) { machine.api_keys.first }
  let(:auth) { { "Authorization" => "Token #{am_key.token}" } }

  include_examples "disallows bad API keys", :get, :index

  it "returns 200 OK" do
    request.headers.merge(auth)
    get :index
    expect(response).to have_http_status :ok
  end

  it "renders active attracts" do
    FactoryBot.create(:attract, starts_at: 1.week.from_now, arcade_machine: machine)
    FactoryBot.create(:attract, starts_at: 1.week.ago, ends_at: 3.days.ago, arcade_machine: machine)
    active = FactoryBot.create(:attract, starts_at: 1.week.ago, arcade_machine: machine)

    request.headers.merge(auth)
    get :index
    list = JSON.parse(response.body)["attracts"]
    expect(list).to eq [active.as_json]
  end

  it "only renders the associated machine's attracts" do
    FactoryBot.create(:attract, starts_at: 1.week.ago)
    active = FactoryBot.create(:attract, starts_at: 1.week.ago, arcade_machine: machine)

    request.headers.merge(auth)
    get :index
    list = JSON.parse(response.body)["attracts"]
    expect(list).to eq [active.as_json]
  end

end
