class Api::UrlsController < ApplicationController
  def create
    result = Url::Creator.call(params: create_url_params)

    if result.success?
      render json: { slug: result.data[:slug] }
    else
      render json: { errors: result.data[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def create_url_params
    params.require(:url).permit(:original_url)
  end
end
