class ArcadeMachine < ActiveRecord::Base
  validates :name, presence: true
end
