require "image_processing/mini_magick"

class StoryThumbUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small:  magick.resize_to_limit!(300, 300),
    }
  end
end
