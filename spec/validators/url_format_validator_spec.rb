RSpec.describe UrlFormatValidator do
  let(:errors) { ActiveModel::Errors.new(OpenStruct.new) }
  let(:record) { instance_double(ActiveModel::Validations, errors: errors) }
  let(:validator) { UrlFormatValidator.new(attributes: { any: true }) }

  def call_subject(value)
    validator.validate_each(record, :original_url, value)
  end

  describe '#validate_each' do
    describe 'validates models' do
      context 'with valid url' do
        %w[
          https://www.example.com/page?param=42
          https://example.com
          http://example.com
          http://ex.market
          http://ex
        ].each do |url|
          it "doesn't create validation errors for #{url}" do
            expect { call_subject(url) }.not_to change(errors, :count)
          end
        end
      end

      context 'with invalid url' do
        [
          'https://www.example.com/page ?param=42',
          'https://exampl e.com',
          'http://example👽.com',
          'ftp://ex.market',
          'andopen.co',
          'andopen'
        ].each do |url|
          it "creates validation errors for #{url}" do
            expect { call_subject(url) }.to change(errors, :count)
          end
        end
      end
    end
  end
end