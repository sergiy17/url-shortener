FactoryBot.define do
  factory :url do
    original_url { 'https://google.com' }
    slug { GenerateString.call }
  end
end
