class Image < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  def url
    # TODO
    "http://example.com/picture.jpg"
  end
end
