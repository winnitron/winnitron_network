module HasImages
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :parent, dependent: :destroy
  end

  def cover_image
    images.find(&:cover) ||
      images.first       ||
      Image.placeholder
  end
end
