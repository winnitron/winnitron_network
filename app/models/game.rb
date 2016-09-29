class Game < ActiveRecord::Base
  acts_as_taggable

  before_validation :strip_whitespace
  before_validation :default_player_counts

  validates :title, presence: true, uniqueness: true

  validate :min_lt_max
  validates :min_players, numericality: { only_integer: true, greater_than: 0 }
  validates :max_players, numericality: { only_integer: true, greater_than: 0 }

  has_many :game_ownerships, dependent: :destroy
  has_many :users, through: :game_ownerships

  has_many :listings, dependent: :destroy
  has_many :playlists, through: :listings

  has_many :links, as: :parent

  accepts_nested_attributes_for :links, allow_destroy: true,
                                        reject_if: proc { |attrs| attrs["url"].blank? }

  def download_url
    return nil if zipfile_key.blank?
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: zipfile_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end

  private

  def strip_whitespace
    self.title.to_s.strip!
  end

  def default_player_counts
    self.min_players ||= 1
    self.max_players ||= [min_players, 1].max
  end

  def min_lt_max
    if max_players && min_players > max_players
      errors.add(:max_players, "must be greater than minimum players")
    end
  end
end
