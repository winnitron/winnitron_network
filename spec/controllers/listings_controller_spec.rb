require "rails_helper"

RSpec.describe ListingsController do
  describe "POST create" do
    context "the game is already in the playlist" do
      it "changes nothing"
    end

    context "the game is not in the playlist" do
      it "adds the game"
    end
  end

end