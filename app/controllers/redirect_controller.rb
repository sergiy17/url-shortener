class RedirectController < ApplicationController
  def redirect
    url = Url.includes(:analytic).find_by(slug: params[:slug])

    if url.nil? || url.analytic&.last_visit_at&.<(1.month.ago)
      return render json: { error: 'Not found' }, status: :not_found

      # or we might redirect the user to default page / home page
    end

    url.analytic.increment_visits!

    redirect_to url.original_url, status: :moved_permanently, allow_other_host: true
  end
end