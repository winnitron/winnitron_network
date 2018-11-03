module HasImages
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :parent, dependent: :destroy

    after_create -> do
      images.create!(file_key: Image::PLACEHOLDERS[self.class.name],
                         user: users.first,
                        cover: true)
    end
  end

end
