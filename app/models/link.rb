class Link < ActiveRecord::Base
  TYPES = ["Website", "Twitter", "Something Else"]

  belongs_to :parent, polymorphic: true

  validates :url, presence: true

  default_scope -> { order(id: :asc) }
  scope :websites, -> { where(link_type: "Website") }
  scope :twitters, -> { where(link_type: "Twitter") }
  scope :others,   -> { where(link_type: "Something Else") }
end