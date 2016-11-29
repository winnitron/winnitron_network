module Slugged
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true, uniqueness: true
    before_validation :set_slug
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug ||= (title || "").parameterize
  end
end