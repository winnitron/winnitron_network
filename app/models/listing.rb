class Listing < ActiveRecord::Base
  belongs_to :game
  belongs_to :playlist

  validates :game, :playlist, presence: true
end