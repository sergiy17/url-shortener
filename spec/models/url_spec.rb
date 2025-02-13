RSpec.describe Url, type: :model do
  describe 'associations' do
    it { expect(described_class.reflect_on_association(:analytic).macro).to eq(:has_one) }
  end

  describe 'validations' do
    context 'uniqueness' do
      describe 'original_url' do
        it 'returns expected error', :aggregate_failures  do
          first_url = FactoryBot.create(:url)
          dup_url = FactoryBot.build(:url, original_url: first_url.original_url)

          expect(dup_url).to_not be_valid
          expect(dup_url.errors.full_messages).to eq(['Original url has already been taken'])
        end
      end

      describe 'slug' do
        let(:dup_slug) { '123xyz456' }

        before do
          allow(GenerateString).to receive(:call).and_return(dup_slug)
        end

        it 'returns error for duplicated slug', :aggregate_failures do
          first_url = FactoryBot.create(:url)
          second_url = FactoryBot.build(:url)

          expect(first_url.slug).to eq(dup_slug)
          expect(second_url.slug).to eq(dup_slug)
          expect(second_url).to_not be_valid
          expect(second_url.errors.full_messages).to eq(['Slug has already been taken'])
        end
      end
    end

    context 'presence' do
      describe 'original_url' do
        it 'returns expected error', :aggregate_failures  do
          url = FactoryBot.build(:url, original_url: nil)

          expect(url).to_not be_valid
          expect(url.errors.full_messages).to eq(['Original url can\'t be blank'])
        end
      end

      describe 'slug' do
        before do
          allow(GenerateString).to receive(:call).and_return(nil)
        end

        it 'returns expected error', :aggregate_failures do
          url = FactoryBot.build(:url)

          expect(url).to_not be_valid
          expect(url.errors.full_messages).to eq(['Slug can\'t be blank'])
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#generate_slug' do
        it 'generates slug', :aggregate_failures do
          url = FactoryBot.build(:url, slug: nil)
          expect(url.slug).to be_nil
          url.valid?
          expect(url.slug).to be_present
        end
      end
    end
  end
end