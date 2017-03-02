module HasImages
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :parent, dependent: :destroy
  end

  def cover_image
    images.find_by(cover: true) ||
      images.first              ||
      Image.placeholder
  end
end
