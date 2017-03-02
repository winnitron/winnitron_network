class GameZip < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates :user, :file_key, :file_last_modified, presence: true
  validate :is_a_zip

  def humanized_filename
    file_key.sub("games/#{game_uuid}-", "")
  end

  def expiring_url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end

  private

  def is_a_zip
    if file_key && file_key[-4..-1].downcase != ".zip"
      errors.add(:file_key, "must be a .zip file")
    end
  end
end