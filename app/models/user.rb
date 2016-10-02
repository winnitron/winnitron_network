class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github, :facebook]

  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :arcade_machines, through: :machine_ownerships

  has_many :game_ownerships, dependent: :destroy
  has_many :games, through: :game_ownerships

  has_many :playlists

  before_validation :clean_twitter_username

  def owns?(item)
    return arcade_machines.include?(item) if item.is_a?(ArcadeMachine)
    return games.include?(item) if item.is_a?(Game)
  end

  def self.from_omniauth(auth)
    where('(provider = ? AND uid = ?) OR (email = ?)',
          auth.provider,
          auth.uid,
          auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  private

  def clean_twitter_username
    (self.twitter_username || "").sub!("@", "")
  end
end
