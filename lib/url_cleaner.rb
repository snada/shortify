module UrlCleaner
  def self.clean(string_url)
    uri = URI.parse(string_url)
    string_url.prepend('http://') unless uri.class < URI::Generic
    return URI.escape(string_url)
  end
end
