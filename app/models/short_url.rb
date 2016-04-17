class ShortUrl < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug, on: :create

  private
    def set_slug
      if self.slug.blank?
        encoded = Base62.encode62(Digest::SHA2.hexdigest(self.url).to_i(16))
        slug_size = 1
        candidate = ""

        loop do
          candidate = encoded[0...slug_size]
          slug_size += 1

          @match = ShortUrl.find_by(slug: candidate)

          if @match
            self.slug = candidate if @match.url == self.url
          else
            self.slug = candidate
          end

          break if slug
        end
      end
    end
end
