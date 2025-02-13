RSpec.describe Analytic, type: :model do
  describe 'associations' do
    it { expect(described_class.reflect_on_association(:url).macro).to eq(:belongs_to) }
  end

  describe 'validations' do
    context 'numericality' do
      describe 'visits' do
        it 'returns expected error', :aggregate_failures  do
          analytic = FactoryBot.build(:analytic, visits: 'abc')
          expect(analytic).to_not be_valid
          expect(analytic.errors[:visits]).to include('is not a number')
        end
      end
    end

    context 'presence' do
      describe 'visits' do
        it 'returns expected error', :aggregate_failures  do
          analytic = FactoryBot.build(:analytic, visits: nil)

          expect(analytic).to_not be_valid
          expect(analytic.errors.full_messages).to include('Visits can\'t be blank')
        end
      end
    end

    context 'greater_than_or_equal_to zero' do
      describe 'visits' do
        it 'returns expected error', :aggregate_failures  do
          analytic = FactoryBot.build(:analytic, visits: -1)

          expect(analytic).to_not be_valid
          expect(analytic.errors.full_messages).to include('Visits must be greater than or equal to 0')
        end
      end
    end
  end

  describe '#increment_visits!' do
    let!(:analytic) { FactoryBot.create(:analytic) }

    it 'increments the visits count' do
      expect { analytic.increment_visits! }.to change { analytic.visits }.by(1)
    end

    it 'updates last_visit_at within a transaction' do
      expect { analytic.increment_visits! }.to change { analytic.last_visit_at }.from(nil)
    end

    it 'rolls back changes if an error occurs', :aggregate_failures do
      allow(analytic).to receive(:touch).and_raise(ActiveRecord::RecordInvalid)

      expect(analytic.visits).to eq(0)
      expect {
        analytic.increment_visits!
      }.to raise_exception ActiveRecord::RecordInvalid
      expect(analytic.reload.visits).to eq(0)
    end
  end
end