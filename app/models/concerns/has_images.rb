module HasImages
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :parent, dependent: :destroy

    after_create :init_cover_photo
  end

  def cover_image
    images.where(cover: true).reorder(id: :desc).first
  end

  def init_cover_photo
    images.create!(file_key: Image::PLACEHOLDERS[self.class.name],
                       user: users.first,
                      cover: true)
  end
end
