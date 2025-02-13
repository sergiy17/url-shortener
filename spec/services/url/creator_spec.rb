RSpec.describe Url::Creator do
  subject(:result) { described_class.call(params: params) }

  context 'when original_url already exists' do
    let!(:existing_url_obj) { FactoryBot.create(:url, original_url: 'https://www.example.com') }
    let(:params) { { original_url: 'https://www.example.com' } }

    it 'returns success' do
      expect(result.success?).to be true
    end

    it 'returns the existing slug' do
      expect(result.data[:slug]).to eq(existing_url_obj.slug)
    end

    it "doesn't create a new record'" do
      expect { result }.not_to change(Url, :count)
    end
  end

  context 'when url is successfully created' do
    let(:params) { { original_url: 'https://www.google.com' } }

    it 'returns success' do
      expect(result.success?).to be true
    end

    it 'returns the slug of created record' do
      returned_slug = result.data[:slug]
      created_record_slug = Url.last.slug

      expect(returned_slug).to eq(created_record_slug)
    end

    it 'creates a new Url record' do
      expect { result }.to change { Url.count }.by(1)
    end
  end

  context 'when url creation fails (invalid original_url)' do
    let(:params) { { original_url: 'invalid-url' } }

    it 'returns failure' do
      expect(result.failure?).to be true
    end

    it 'returns errors' do
      expect(result.data[:errors]).to be_present
    end

    it 'does not create a new Url record' do
      expect { result }.not_to change { Url.count }
    end
  end

  context 'when an unexpected error occurs during save!' do
    let(:params) { { original_url: 'https://www.example.com' } }

    before do
      allow_any_instance_of(Url).to receive(:save).and_raise(StandardError, 'error')
    end

    it 'returns failure' do
      expect(result.failure?).to be true
    end

    it 'returns an error message' do
      expect(result.data[:message]).to eq('error')
    end

    it 'calls ReportException service' do
      expect(ReportException).to receive(:call).with(an_instance_of(StandardError))
      result
    end
  end
end