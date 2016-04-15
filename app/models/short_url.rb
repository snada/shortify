class ShortUrl < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true
end
