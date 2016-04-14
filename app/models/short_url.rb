class ShortUrl < ActiveRecord::Base
  validates :url, presence: true
  validates :slug, presence: true, uniqueness: true
end
