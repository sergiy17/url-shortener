RSpec.describe UrlSerializer, type: :serializer do
  let(:url) { FactoryBot.create(:url) }
  let(:serialized) { described_class.new(url).serializable_hash }

  it 'serializes the url with correct attributes' do
    expect(serialized[:slug]).to eq(url.slug)
    expect(serialized[:original_url]).to eq(url.original_url)
    expect(serialized[:visits]).to eq(url.analytic.visits)
    expect(serialized[:last_visit_at]).to eq(url.analytic.last_visit_at)
  end
end
