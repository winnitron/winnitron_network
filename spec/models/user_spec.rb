require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "#owns?" do
    let(:mine) { FactoryBot.create(:arcade_machine) }
    let(:theirs) { FactoryBot.create(:arcade_machine) }

    it "returns true if the user owns it" do
      MachineOwnership.create user: user, arcade_machine: mine
      expect(user.owns?(mine)).to be_truthy
    end

    it "returns false if they don't" do
      expect(user.owns?(theirs)).to be_falsey
    end

    it "fails if the object is not ownable" do
      expect {
        user.owns?(String.new)
      }.to raise_error(ArgumentError)
    end
  end

  describe "#can_download?" do
    let(:game) { FactoryBot.create(:game) }
    let(:some_chump) { FactoryBot.build(:user) }
    let(:admin) { FactoryBot.build(:admin) }
    let(:builder) { FactoryBot.create(:builder) }
    let(:owner) { game.users.first }

    it "allows admins" do
      expect(admin.can_download?(game)).to be true
    end

    it "allows builders" do
      expect(builder.can_download?(game)).to be true
    end

    it "allows owners" do
      expect(owner.can_download?(game)).to be true
    end

    it "disallows pathetic nobodies" do
      expect(some_chump.can_download?(game)).to be false
    end

  end
end
