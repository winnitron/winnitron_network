class Playlist < ActiveRecord::Base
  validates :title, :user, presence: true

  belongs_to :user

  has_many :listings, dependent: :destroy
  has_many :games, through: :listings

  scope :defaults, -> { where(default: true) }

  # TODO: title can't start with an underscore
end