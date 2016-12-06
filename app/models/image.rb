class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :user, presence: true

  default_scope { order(cover: :desc) }

  def self.placeholder
    Image.new(file_key: "games/420afd91-2a29-4d21-bff1-94aaa603f48f-image-blank_grey.png")
  end

  def url(w: nil, h: nil)
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    source = object.public_url

    if w || h
      resized = Cloudimage::Image.new(source)
      resized.crop!(w, h)
      resized.url
    else
      source
    end
  end
end
