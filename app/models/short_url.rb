class ShortUrl < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true

  scope :by_shortest_slug, -> { order("LENGTH(slug) ASC") }

  def self.slug_for(url)
    short_url = self.where(url: url).by_shortest_slug.first
    slug = short_url.slug if short_url

    if slug.blank?
      encoded = Base62.encode62(Digest::SHA2.hexdigest(url).to_i(16))
      slug_size = 1
      candidate = ""

      loop do
        candidate = encoded[0...slug_size]
        slug_size += 1

        @match = self.find_by(slug: candidate)

        if @match
          slug = candidate if @match.url == url
        else
          slug = candidate
        end

        break if slug
      end
    end

    slug
  end

end
