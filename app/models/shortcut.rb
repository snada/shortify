class Shortcut < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true

  scope :by_shortest_slug, -> { order("LENGTH(slug) ASC") }

  def self.slug_for(url)
    shortcut = self.where(url: url).by_shortest_slug.first
    slug = shortcut.slug if shortcut

    if slug.blank?
      encoded = Base62.encode62(Digest::SHA2.hexdigest(url).to_i(16))

      substrings = encoded.split('').inject([]) do |subs, char|
        subs << subs.last.to_s + char
      end

      max_len = Shortcut.select('MAX(LENGTH(slug)) AS max_len').where(slug: substrings).order('max_len').first['max_len']
      length = max_len ? max_len + 1 : 1

      slug = encoded[0...length]
    end

    return slug
  end
end
