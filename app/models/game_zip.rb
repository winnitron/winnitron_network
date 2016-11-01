class GameZip < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates :user, presence: true

end