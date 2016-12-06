require "rails_helper"

RSpec.describe Image, type: :model do
  let(:image) { Image.new(file_key: "example.jpg") }
  let(:aws_url) { "https://#{ENV['AWS_BUCKET']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/#{image.file_key}" }

  before :each do
    allow_any_instance_of(Aws::S3::Object).to receive(:public_url).and_return(aws_url)
  end

  describe "#url" do
    it "without dimensions, it gives the original URL" do
      expect(image.url).to eq aws_url
    end

    it "given dimensions it returns the cloudimage.io URL" do
      expect(image.url(w: 100, h: 200)).to include(aws_url)
      expect(image.url(w: 100, h: 200)).to include("cloudimg.io")
    end
  end
end