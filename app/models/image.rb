class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :user, :file_key, presence: true

  default_scope { order(cover: :desc, id: :desc) }

  def self.placeholder
    Image.new(file_key: "ben-neale-297658.jpg")
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

  def gif?
    file_key[-3..-1].downcase == "gif"
  end
end
