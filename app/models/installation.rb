class Installation < ActiveRecord::Base
  belongs_to :game
  belongs_to :arcade_machine

  validates :game, :arcade_machine, presence: true
end
