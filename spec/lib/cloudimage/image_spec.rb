require "rails_helper"

describe Cloudimage::Image do
  let(:image) { Cloudimage::Image.new("http://example.com/pic.jpg") }

  describe "#default!" do
    before :each do
      image.default!
    end

    it "removes dimensions" do
      expect(image.width).to be_nil
      expect(image.height).to be_nil
    end

    it "sets operation to 'cdn'" do
      expect(image.operation).to eq "cdn"
    end
  end

  describe "#crop!" do
    it "sets dimensions" do
      image.crop!(100, 200)
      expect(image.width).to eq 100
      expect(image.height).to eq 200
    end

    context "both dimensions supplied" do
      it "sets operation to 'crop'" do
        image.crop!(100, 200)
        expect(image.operation).to eq "crop"
      end
    end

    context "only width supplied" do
      it "sets operation to 'width'" do
        image.crop!(100)
        expect(image.operation).to eq "width"
      end
    end

    context "only height supplied" do
      it "sets operation to 'height'" do
        image.crop!(nil, 200)
        expect(image.operation).to eq "height"
      end
    end
  end

  describe "#url" do
    it "joins components" do

      base = "https://#{ENV['CLOUDIMAGE_TOKEN']}.cloudimg.io/s"
      image.crop!(100, 200)
      expect(image.url).to eq "#{base}/crop/100x200/http://example.com/pic.jpg"
    end
  end

end