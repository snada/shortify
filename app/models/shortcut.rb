class Shortcut < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true

  scope :by_shortest_slug, -> { order("LENGTH(slug) ASC") }
  scope :by_longest_slug, -> { order("LENGTH(slug) DESC") }

  def self.slug_for(url)
    shortcut = self.where(url: url).by_shortest_slug.first
    slug = shortcut.slug if shortcut

    if slug.blank?
      encoded = Base62.encode62(Digest::SHA2.hexdigest(url).to_i(16))

      substrings = encoded.split('').inject([]) do |subs, char|
        subs << subs.last.to_s + char
      end


      shortcut = Shortcut.where(slug: substrings).by_longest_slug.first
      length = shortcut ? (shortcut.slug.length + 1) : 1

      slug = encoded[0...length]
    end

    slug
  end
end
