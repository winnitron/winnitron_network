class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :machine_ownerships, dependent: :destroy
  has_many :arcade_machines, through: :machine_ownerships

  def owns?(machine)
    arcade_machines.include?(machine)
  end

end
