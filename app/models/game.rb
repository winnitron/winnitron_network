class Game < ActiveRecord::Base
  validates :title, presence: true

  def download_url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: s3_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end
end
