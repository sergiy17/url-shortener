class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      valid = URI.parse(value).is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      valid = false
    end

    record.errors.add(attribute, (options[:message] || 'is not an url')) unless valid
  end
end
