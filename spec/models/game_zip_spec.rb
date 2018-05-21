require "rails_helper"

RSpec.describe GameZip, type: :model do

  describe "#likely_executable" do
    let(:zip) { GameZip.new }

    it "chooses an exe file if there is one" do
      files = %w(foo.exe bar.html baz.jpg)
      allow(zip).to receive(:root_files).and_return(files)

      expect(zip.likely_executable).to eq "foo.exe"
    end

    it "chooses an html file if there is one, but no exe file" do
      files = %w(foo.ext bar.html baz.jpg)
      allow(zip).to receive(:root_files).and_return(files)

      expect(zip.likely_executable).to eq "bar.html"
    end

    it "returns nil if there aren't any good choices" do
      files = %w(foo.ext bar.something baz.jpg)
      allow(zip).to receive(:root_files).and_return(files)

      expect(zip.likely_executable).to eq nil
    end
  end
end