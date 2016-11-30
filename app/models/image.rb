class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :user, presence: true

  default_scope { order(cover: :desc) }

  def self.placeholder
    Image.new(file_key: "games/420afd91-2a29-4d21-bff1-94aaa603f48f-image-blank_grey.png")
  end

  def url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    object.public_url
  end
end
