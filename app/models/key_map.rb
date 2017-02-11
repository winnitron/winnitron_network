class KeyMap < ActiveRecord::Base
  enum template: [:default, :legacy, :flash, :custom]

  belongs_to :game
end