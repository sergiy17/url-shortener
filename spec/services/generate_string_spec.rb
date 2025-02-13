RSpec.describe GenerateString do
  describe '.call' do
    context 'without params' do
      subject(:result_without_params) { described_class.call }

      it 'generates a 10-character string' do
        expect(result_without_params.length).to eq(10)
      end

      it 'generates a base58 string' do
        expect(result_without_params).to match(/^[1-9a-zA-Z]+$/)
      end

      it 'generates a random string' do
        result2 = described_class.call
        expect(result_without_params).not_to eq(result2)
      end
    end

    context 'with params' do
      let(:length) { 15 }
      subject(:result_with_params) { described_class.call(length) }

      it 'generates a string of the specified length' do
        expect(result_with_params.length).to eq(length)
      end

      it 'generates a base58 string' do
        expect(result_with_params).to match(/^[1-9a-zA-Z]+$/)
      end

      it 'generates a random string' do
        result2 = described_class.call(length)
        expect(result_with_params).not_to eq(result2)
      end
    end
  end
end