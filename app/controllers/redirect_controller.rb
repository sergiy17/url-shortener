class RedirectController < ApplicationController
  def redirect
    url = Url.find_by(slug: params[:slug])

    return render json: { error: 'Not found' }, status: :not_found if url.nil?
    # or we might redirect the user to default page / home page

    redirect_to url.original_url, status: :moved_permanently, allow_other_host: true
  end
end