class Image < ActiveRecord::Base
  PLACEHOLDERS = {
    "Game" => "element5-digital-763867-high-score.jpg",
    "ArcadeMachine" => "pete-pedroza-701024-less-evil.jpg",
    "Playlist" => "element5-digital-763867-high-score.jpg",
    "legacy" => "ben-neale-297658.jpg"
  }
  PLACEHOLDERS.default = "blank.png"

  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :file_key, presence: true

  after_create :update_cover_photo
  after_destroy :reinstate_placeholder_cover

  def placeholder?
    PLACEHOLDERS.values.include?(file_key)
  end

  def url(w: nil, h: nil)
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    source = object.public_url

    if w || h
      resized = Cloudimage::Image.new(source)
      resized.crop!(w, h)
      resized.url
    else
      source
    end
  end

  def gif?
    file_key[-3..-1].downcase == "gif"
  end

  private

  def update_cover_photo
    return if placeholder?

    parent.images.select(&:placeholder?).each(&:delete)
    if parent.images.where(cover: true).empty?
      parent.images.reorder(id: :asc).first.update(cover: true)
    end
  end

  def reinstate_placeholder_cover
    return if parent.images.reload.any?
    parent.init_cover_photo
  end
end
