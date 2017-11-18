class Play < ActiveRecord::Base
  belongs_to :arcade_machine
  belongs_to :game

  validates :arcade_machine, :game, :start, presence: true
end
