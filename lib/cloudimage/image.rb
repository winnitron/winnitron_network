module Cloudimage
  class Image
    attr_reader :original_url, :operation, :width, :height

    def initialize(original_url)
      @original_url = original_url
      @base_url     = "https://#{ENV['CLOUDIMAGE_TOKEN']}.cloudimg.io/s"
      default!
    end

    def default!
      @operation = "cdn"
      @width  = nil
      @height = nil
    end

    def crop!(width = nil, height = nil)
      @operation = "crop"   if width  && height
      @operation = "width"  if width  && !height
      @operation = "height" if !width && height

      @width  = width
      @height = height
    end

    def size
      [width, height].compact.join("x")
    end

    def url
      [
        @base_url,
        operation,
        size,
        original_url
      ].join("/")
    end
  end
end