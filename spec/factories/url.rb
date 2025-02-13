FactoryBot.define do
  factory :url do
    # the reason we use SecureRandom.base58(10) here but not GenerateString.call
    # is because GenerateString.call could be mocked

    original_url { "https://google.com/#{SecureRandom.base58(10)}" }
    slug { GenerateString.call }
  end
end
