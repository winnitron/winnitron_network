class Playlist < ActiveRecord::Base
  validates :title, :user, presence: true

  belongs_to :user

  has_many :listings, dependent: :destroy
  has_many :games, through: :listings
end