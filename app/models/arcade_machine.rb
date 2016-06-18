class ArcadeMachine < ActiveRecord::Base
  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :users, through: :machine_ownerships

  has_many :installations, dependent: :destroy
  has_many :games, through: :installations

  has_many :api_keys
end
