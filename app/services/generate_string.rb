class GenerateString
  def self.call(length = 10)
    SecureRandom.base58(length)
  end
end