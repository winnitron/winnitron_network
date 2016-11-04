class ArcadeMachine < ActiveRecord::Base
  include HasImages

  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :users, through: :machine_ownerships

  has_many :subscriptions, dependent: :destroy
  has_many :playlists, through: :subscriptions

  has_many :api_keys, dependent: :destroy
  has_many :links, as: :parent, dependent: :destroy

  after_create :subscribe_to_defaults

  accepts_nested_attributes_for :links, allow_destroy: true,
                                        reject_if: proc { |attrs| attrs["url"].blank? }

  def subscribed?(playlist)
    playlists.include?(playlist)
  end

  private

  def subscribe_to_defaults
    Playlist.defaults.each do |playlist|
      subscriptions.create playlist: playlist
    end
  end
end
