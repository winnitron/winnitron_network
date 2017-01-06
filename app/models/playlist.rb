class Playlist < ActiveRecord::Base
  include Slugged

  acts_as_taggable_on :smart_tags

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

  def smart?
    smart_tags.any?
  end

  def games
    smart? ? smart_games : super
  end

  private

  def smart_games
    # Yes, this is inefficient but I'll worry about that when we have
    # enough games for it to matter.
    Game.with_zip.select do |g|
      (g.tag_list & smart_tags.pluck(:name)).size == smart_tags.size
    end
  end

  def title_doesnt_start_with_underscore
    errors.add(:title, "can't start with an underscore") if title && title[0] == "_"
  end
end