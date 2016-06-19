class Game < ActiveRecord::Base
  acts_as_taggable
  
  validates :title, presence: true, uniqueness: true

  has_many :game_ownerships, dependent: :destroy
  has_many :users, through: :game_ownerships

  has_many :listings, dependent: :destroy
  has_many :playlists, through: :listings

  has_many :installations, dependent: :destroy
  has_many :arcade_machines, through: :installations

  def download_url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: zipfile_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end
end
