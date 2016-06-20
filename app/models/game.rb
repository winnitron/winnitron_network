class Game < ActiveRecord::Base
  acts_as_taggable
  
  validates :title, presence: true, uniqueness: true

  has_many :game_ownerships, dependent: :destroy
  has_many :users, through: :game_ownerships

  has_many :listings, dependent: :destroy
  has_many :playlists, through: :listings

  before_validation :strip_whitespace

  def download_url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: zipfile_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end

  private

  def strip_whitespace
    self.title.to_s.strip!
  end
end
