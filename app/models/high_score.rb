class HighScore < ActiveRecord::Base
  belongs_to :game
  belongs_to :arcade_machine

  validates :name, :game, :score, presence: true
end
