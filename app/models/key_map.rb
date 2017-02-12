class KeyMap < ActiveRecord::Base
  enum template: [:default, :custom, :legacy, :flash, :pico8]

  belongs_to :game
end