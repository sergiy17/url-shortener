class Api::UrlsController < ApplicationController
  def index
    urls = Url.includes(:analytic).paginate(page: params[:page], per_page: params[:per_page])

    serialized_urls = ActiveModel::Serializer::CollectionSerializer.new(urls, serializer: UrlSerializer).as_json

    render json: {
      data: serialized_urls,
      meta: pagination_meta(urls)
    }
  end

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

  def pagination_meta(object)
    {
      current_page: object.current_page,
      total_pages: object.total_pages,
      total_count: object.total_entries,
      per_page: object.per_page
    }
  end
end
