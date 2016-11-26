module HasImages
  extend ActiveSupport::Concern

  included do
    after_save :attach_images
    has_many :images, as: :parent, dependent: :destroy
  end

  def cover_image
    images.find_by(cover: true) ||
      images.first              ||
      Image.placeholder
  end

  private

  def attach_images
    Image.where(parent_uuid: uuid).each do |image|
      image.update(parent: self)
    end
  end

end