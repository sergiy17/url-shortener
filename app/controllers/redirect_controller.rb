class RedirectController < ApplicationController
  def redirect
    url = Url.find_by(slug: params[:slug])

    return render :not_found, status: 404 if url.nil?
    # or we might redirect the user to default page / home page

    redirect_to url.original_url, status: 301, allow_other_host: true
  end
end