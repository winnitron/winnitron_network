class Playlist < ActiveRecord::Base
  include Slugged

  validates :title, :user, presence: true
  validate :title_doesnt_start_with_underscore

  belongs_to :user

  has_many :listings, dependent: :destroy
  has_many :games, through: :listings

  has_many :subscriptions, dependent: :destroy
  has_many :arcade_machines, through: :subscriptions

  scope :defaults, -> { where(default: true) }

  def cover_image
    games.map(&:cover_image).compact.first || Image.placeholder
  end

  private

  def title_doesnt_start_with_underscore
    errors.add(:title, "can't start with an underscore") if title && title[0] == "_"
  end
end