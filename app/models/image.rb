class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  def url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end
end
