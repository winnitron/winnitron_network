require "rails_helper"

RSpec.describe GamesController, type: :controller do
  describe "update" do
    it "requires ownership"
    it "sets the cover image"
    it "ensures only one cover image"
  end

  describe "destroy" do
    it "requires ownership"
    it "deletes the image"
  end
end