RSpec.describe UrlSerializer, type: :serializer do
  let(:url) { FactoryBot.create(:url) }
  let(:serialized) { described_class.new(url).serializable_hash }

  it 'serializes the url with correct attributes', :aggregate_failures  do
    expect(serialized[:shortened_link]).to be_present
    expect(serialized[:slug]).to eq(url.slug)
    expect(serialized[:original_url]).to eq(url.original_url)
    expect(serialized[:visits]).to eq(url.analytic.visits)
    expect(serialized[:last_visit_at]).to eq(url.analytic.last_visit_at)
  end

  describe 'shortened_link' do
    it 'builds the link correctly' do
      protocol = 'http'
      host = Rails.application.config.action_controller.default_url_options[:host]
      slug = url.slug

      expect(serialized[:shortened_link]).to eq("#{protocol}://#{host}/#{slug}")
    end
  end
end
