class UpdateVisitStatsJob < ApplicationJob
  queue_as :default

  def perform(slug)
    url = Url.find_by(slug: slug)
    url&.analytic&.update_visit_stats!
    # prob we don't need to log the 'not found' results
  end
end