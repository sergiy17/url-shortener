RSpec.describe UpdateVisitStatsJob, type: :job do
  describe '#perform' do
    let!(:url) { FactoryBot.create(:url) }

    it 'updates visit stats for the given slug' do
      expect(url.analytic.visits).to eq(0)
      expect(url.analytic.last_visit_at).to be_nil

      UpdateVisitStatsJob.perform_now(url.slug)

      url.analytic.reload

      expect(url.analytic.visits).to eq(1)
      expect(url.analytic.last_visit_at).to_not be_nil
    end
  end
end