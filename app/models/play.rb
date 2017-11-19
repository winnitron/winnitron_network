class Play < ActiveRecord::Base
  belongs_to :arcade_machine
  belongs_to :game

  validates :arcade_machine, :game, :start, presence: true

  scope :complete, -> { where.not(stop: nil) }

  def duration
    ((stop || Time.now.utc) - start).to_i
  end
end
