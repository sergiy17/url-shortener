class Url::Creator < Micro::Case::Strict
  attributes :params

  def call!
    return url.slug if url.present?

    url = Url.new(params)
    if url.save
      Success(result: { slug: url.slug })
    else
      Failure(result: { errors: url.errors.full_messages })
    end
  rescue ActiveRecord::RecordInvalid => e
    ReportException.call(e)
    Failure(result: { message: e.message })
  end

  private

  def url
    @url ||= Url.find_by(original_url: params[:original_url])
  end
end
