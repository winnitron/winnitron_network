require "rails_helper"

RSpec.describe ArcadeMachine, type: :model do
  let(:arcade_machine) { FactoryBot.create(:arcade_machine) }

  it "creates an api key" do
    am = ArcadeMachine.create(title: "Robot Overlord", players: 2, location: Location.new(city: "Right Behind You"))
    expect(am.api_keys).to_not be_empty
  end

  describe "#subscribed?" do
    let(:good_playlist) { FactoryBot.create(:playlist) }
    let(:bad_playlist)  { FactoryBot.create(:playlist) }

    before :each do
      Subscription.create! arcade_machine: arcade_machine, playlist: good_playlist
    end

    it "is true for playlists subscribed to" do
      expect(arcade_machine.subscribed?(good_playlist)).to eq true
    end

    it "is false for playlists not subscribed to" do
      expect(arcade_machine.subscribed?(bad_playlist)).to eq false
    end
  end

  describe "#approved?" do
    it "is true if there is an approved request" do
      expect(arcade_machine).to be_approved
    end

    it "is false if non-approved request" do
      arcade_machine.approval_request.update(approved_at: nil)
      expect(arcade_machine).to_not be_approved
    end

    it "is false if no request" do
      arcade_machine.approval_request.destroy
      arcade_machine.reload
      expect(arcade_machine).to_not be_approved
    end
  end

  describe "default playlists" do
    let!(:default_playlist) { FactoryBot.create(:playlist, default: true) }
    let!(:nondefault_playlist) { FactoryBot.create(:playlist, default: false) }

    it "automatically subscribes to defaults" do
      expect(arcade_machine.playlists).to include(default_playlist)
    end

    it "does not subscribe to non-defaults" do
      expect(arcade_machine.playlists).to_not include(nondefault_playlist)
    end
  end

end