class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      uri = URI.parse(value)
      unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
        record.errors[attribute] << (options[:message] || "uses an unsupported protocol")
      end
    rescue URI::InvalidURIError
      record.errors[attribute] << (options[:message] || "is not a valid uri")
    end
  end
end
