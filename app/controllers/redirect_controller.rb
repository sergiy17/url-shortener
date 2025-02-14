class RedirectController < ApplicationController
  def redirect
    original_url = Rails.cache.fetch("url:#{params[:slug]}", expires_in: 1.day) do
      url = Url.includes(:analytic).find_by(slug: params[:slug])
      url&.original_url if url&.analytic&.last_visit_at.nil? || url&.analytic&.last_visit_at&.>=(1.month.ago)
    end

    if original_url.nil?
      return render json: { error: 'Not found' }, status: :not_found
      # or we might redirect the user to default page / home page
    end

    UpdateVisitStatsJob.perform_later(params[:slug])

    redirect_to original_url, status: :moved_permanently, allow_other_host: true
  end
end
