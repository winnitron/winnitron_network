class Game < ActiveRecord::Base
  validates :title, presence: true
end
