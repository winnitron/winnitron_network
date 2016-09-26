class Link < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  validates :url, presence: true
end