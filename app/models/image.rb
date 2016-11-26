class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :user, presence: true

  default_scope { order(cover: :desc) }

  def self.placeholder
    # Uh, or something.
    Image.new(file_key: "games/24504476-e730-4aef-b7ed-bd3fd956c3c4-image-NCC-1701-D.jpg")
  end

  def url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end
end
