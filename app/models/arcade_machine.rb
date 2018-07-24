class ArcadeMachine < ActiveRecord::Base
  include HasImages
  include Slugged

  # before_validation :clean_location
  # geocoded_by :location
  # after_validation :geocode, if: :should_geocode?

  validates :title, presence: true
  validates :players, numericality: { only_integer: true, greater_than: 1 }

  has_many :machine_ownerships, dependent: :destroy
  has_many :users, through: :machine_ownerships

  has_many :subscriptions, dependent: :destroy
  has_many :playlists, through: :subscriptions
  has_many :games, through: :playlists

  has_many :api_keys, dependent: :destroy
  has_many :links, as: :parent, dependent: :destroy

  has_many :plays

  has_one :approval_request, as: :approvable, dependent: :destroy
  has_one :location, as: :parent, dependent: :destroy

  after_create :subscribe_to_defaults

  scope :approved, -> { joins(:approval_request).where("approval_requests.approved_at IS NOT NULL") }

  accepts_nested_attributes_for :links, allow_destroy: true,
                                        reject_if: proc { |attrs| attrs["url"].blank? }

  delegate :approved?, to: :approval_request, allow_nil: true

  def subscribed?(playlist)
    playlists.include?(playlist)
  end

  private

  def should_geocode?
    mappable? && ((location && location_changed?) || mappable_changed?)
  end

  def clean_location
    return if location.present?

    self.location = nil
    self.latitude = nil
    self.longitude = nil
  end

  def subscribe_to_defaults
    Playlist.defaults.each do |playlist|
      subscriptions.create playlist: playlist
    end
  end
end
