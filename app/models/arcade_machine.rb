class ArcadeMachine < ActiveRecord::Base
  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :users, through: :machine_ownerships

  has_many :subscriptions, dependent: :destroy
  has_many :playlists, through: :subscriptions

  has_many :api_keys, dependent: :destroy

  def subscribed?(playlist)
    subscriptions.include?(playlist)
  end
end
