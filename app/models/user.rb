class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :arcade_machines, through: :machine_ownerships

  has_many :game_ownerships, dependent: :destroy
  has_many :games, through: :game_ownerships

  def owns?(item)
    return arcade_machines.include?(item) if item.is_a?(ArcadeMachine)
    return games.include?(item) if item.is_a?(Game)
  end

end
