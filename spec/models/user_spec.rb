require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  describe "#owns?" do
    let(:mine) { FactoryGirl.create(:arcade_machine) }
    let(:theirs) { FactoryGirl.create(:arcade_machine) }

    it "returns true if the user owns it" do
      MachineOwnership.create user: user, arcade_machine: mine
      expect(user.owns?(mine)).to be_truthy
    end

    it "returns false if they don't" do
      expect(user.owns?(theirs)).to be_falsey
    end

  end
end
