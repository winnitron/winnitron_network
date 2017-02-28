class Game < ActiveRecord::Base
  include HasImages
  include Slugged

  CUSTOM_LINK_TYPES = ["Itch.io", "Trailer"]

  acts_as_taggable

  before_validation :strip_whitespace
  before_validation :default_player_counts
  after_save :attach_game_zips
  after_save :update_smart_listings
  after_create -> { KeyMap.create!(game: self) }

  validates :title, presence: true, uniqueness: true

  validate :min_lt_max
  validates :min_players, numericality: { only_integer: true, greater_than: 0 }
  validates :max_players, numericality: { only_integer: true, greater_than: 0 }


  has_one :key_map

  has_many :game_zips, dependent: :destroy

  has_many :game_ownerships, dependent: :destroy
  has_many :users, through: :game_ownerships

  has_many :listings, dependent: :destroy
  has_many :playlists, through: :listings

  has_many :arcade_machines, through: :playlists

  has_many :links, as: :parent, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true,
                                        reject_if: proc { |attrs| attrs["url"].blank? }

  scope :with_zip, -> { where(id: GameZip.pluck(:game_id)) }
  scope :published, -> { where.not(published_at: nil) }

  def download_url
    return nil if game_zips.empty?
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: current_zip.file_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end

  def current_zip
    game_zips.reorder(created_at: :desc).first
  end

  def qualifies_for_playlist?(playlist)
    return true if !playlist.smart?

    playlist.smart_tags.all? { |t| tags.include?(t) }
  end

  def published?
    !!published_at
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

  def attach_game_zips
    GameZip.where(game_uuid: uuid).each do |zip|
      zip.update(game_id: self.id)
    end
  end

  def update_smart_listings
    listings.select { |l| l.playlist.smart? }.each(&:destroy)
    reload

    playlists = Playlist.all.select(&:smart?).select { |p| qualifies_for_playlist?(p) }

    playlists.each do |playlist|
      listings.create(playlist: playlist)
    end
  end
end
