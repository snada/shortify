class Shortcut < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true, format: {
    with: /[0-9A-Za-z]/,
    message: "only accepts 0-9 digits and letters."
  }

  scope :by_shortest_slug, -> { order("LENGTH(slug) ASC") }

  def self.slug_for(url)
    shortcut = self.where(url: url).by_shortest_slug.first
    slug = shortcut.slug if shortcut

    if slug.blank?
      encoded = Base62.encode62(Digest::SHA2.hexdigest(url).to_i(16))
      slug_size = 1
      candidate = ""

      loop do
        candidate = encoded[0...slug_size]
        slug_size += 1

        match = self.find_by(slug: candidate)

        if match
          slug = candidate if match.url == url
        else
          slug = candidate
        end

        break if slug
      end
    end

    slug
  end

end
