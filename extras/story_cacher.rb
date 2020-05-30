class StoryCacher
  cattr_accessor :DIFFBOT_API_KEY

  # this needs to be overridden in config/initializers/production.rb
  @@DIFFBOT_API_KEY = nil

  DIFFBOT_API_URL = "http://www.diffbot.com/api/article".freeze

  def self.get_story_text(story)
    # if !@@DIFFBOT_API_KEY
    #   return
    # end

    # XXX: diffbot tries to read pdfs as text, so disable for now
    if story.url.to_s.match(/\.pdf$/i)
      return nil
    end

    # db_url = "#{DIFFBOT_API_URL}?token=#{@@DIFFBOT_API_KEY}&url=#{CGI.escape(story.url)}"

    begin
      # s = Sponge.new
      # # we're not doing this interactively, so take a while
      # s.timeout = 45
      # res = s.fetch(db_url).body
      # if res.present?
      #   j = JSON.parse(res)

      #   # turn newlines into double newlines, so they become paragraphs
      #   j["text"] = j["text"].to_s.gsub("\n", "\n\n")

      #   while j["text"].match("\n\n\n")
      #     j["text"].gsub!("\n\n\n", "\n\n")
      #   end

      #   return j["text"]
      # end
      # content = open(story.url).read; true;
      # content = Boilerpipe::Extractors::LargestContentExtractor.text(content)
      doc = LinkThumbnailer.generate(story.url)

      # Handle thumb
      if doc.images.any?
        story.thumb = { id: doc.images.first.src.to_s, storage: :cache }
        story.thumb_derivatives!
        story.thumb_attacher.promote
      end

      # turn newlines into double newlines, so they become paragraphs
      content = doc.description.to_s.gsub("\n", "\n\n")

      while content.match("\n\n\n")
        content.gsub!("\n\n\n", "\n\n")
      end

      return RemoveEmoji::Sanitize.call(content)

    rescue => e
      Rails.logger.error "error fetching #{story.url}: #{e.message}"
    end

    begin
      s = Sponge.new
      s.timeout = 45
      s.fetch(story.archive_url)
    rescue => e
      Rails.logger.error "error caching #{db_url}: #{e.message}"
    end

    nil
  end
end
