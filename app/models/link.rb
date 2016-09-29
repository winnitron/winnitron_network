class Link < ActiveRecord::Base
  TYPES = ["Website", "Twitter", "Itch.io", "Something Else"]

  belongs_to :parent, polymorphic: true

  validates :url, presence: true

  default_scope -> { order(id: :asc) }
end