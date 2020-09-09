module HasImages
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :parent, dependent: :destroy

    after_create :init_cover
  end

  def cover_image
    images.find(&:cover)
  end

  def init_cover
    images.create!(file_key: Image::PLACEHOLDERS[self.class.name],
                       user: users.first,
                      cover: true)
  end

  def set_cover(image)
    images.reload

    raise "Image #{image.id} doesn't belong to #{self.class.name} #{id}" if !images.include?(image)
    images.update_all(cover: false)
    image.update(cover: true)
  end
end
